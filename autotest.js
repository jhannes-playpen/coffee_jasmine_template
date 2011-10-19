var fs = require("fs"),
    path = require("path"),
    filescanner = require("./build/filescanner"),
    coffee = require('./build/coffee-script')
    ;

var compileCoffee = function(coffee_file, status_reporting) {
  var js_file = coffee_file.replace(/\.coffee$/, ".js").replace(/\/src/, "/app/src").replace(/\/spec/, "/app/spec");
  var jsFilePresent = path.existsSync(js_file);
  if (jsFilePresent && fs.statSync(coffee_file).mtime <= fs.statSync(js_file).mtime) return;
  console.log("compiling", coffee_file);
  fs.unlink(js_file, function() {
    try {
      var js_src = coffee.CoffeeScript.compile(fs.readFileSync(coffee_file, "utf8"));
      if (!jsFilePresent) {
        status_reporting.compile_ok(js_file);
      } else {
        status_reporting.recompile_ok(js_file);
      }
      fs.writeFileSync(js_file, js_src, "utf8");
    } catch (err) {
      status_reporting.compile_failures(coffee_file + ": " + err.message);
    }
  });
}
    
var compile = function(file, status_reporting) {
  if ( file.match(/.coffee$/) ) compileCoffee(file, status_reporting);
};

var deleteCompiledFile = function(original) {
  if ( original.match(/.coffee$/) ) {
    var js_file = original.replace(/\.coffee$/, ".js").replace(/\/src/, "/app/src").replace(/\spec/, "/app/spec");
    console.log("deleting", js_file);
    fs.unlinkSync(js_file);
  }
};

var executeJasmineTests = function(status_reporting) {
  var removeJasmineFrames = function (text) {
    var lines = [];
    text.split(/\n/).forEach(function(line){
      if (line.indexOf("build/jasmine-core") == -1) {
        lines.push(line);
      }
    });
    return lines.join('\n');
  };

  console.log("running tests");
  var sys = require("sys");
  var jasmineCore = require('./build/jasmine-core/jasmine');
  var TerminalReporter = require('./build/jasmine-core/reporter').TerminalReporter;
  for(var key in jasmineCore) {
    global[key] = jasmineCore[key];
  }
  
  var jasmineComplete = function(runner,log) {
    var messages = []
    var tests = 0;
    for (var i=0; i<runner.topLevelSuites().length; i++) {
      for (var j=0; j<runner.topLevelSuites()[i].specs().length; j++) {
        tests += 1;
        var spec = runner.topLevelSuites()[i].specs()[j];
        if (spec.results().failedCount > 0) {
          var spec_messages = [];
          for (var k=0; k<spec.results().getItems().length; k++) {
            var item = spec.results().getItems()[k];
            if (!item.passed()) {
              spec_messages.push(item.message);
            }
          }
          messages.push(spec.results().description + ": " + spec_messages.join(", "));
        }
      }
    }
    if (messages.length > 0) {
      status_reporting.test_failures(messages.join("\n"));
    } else if (tests == 0) {
      status_reporting.test_none_ran("No tests");
    } else {
      status_reporting.test_success(tests + " tests ok");
    }
  };

  jasmine.currentEnv_ = new jasmine.Env();
  var jasmineEnv = jasmine.getEnv();
  jasmineEnv.addReporter(new TerminalReporter({print:sys.print,verbose:true,color:true,onComplete:jasmineComplete,stackFilter: removeJasmineFrames}));
  var exports = this.exports || {};
  var src_files = fs.readdirSync("./app/src");
  for (var i=0; i<src_files.length; i++) {
    if (src_files[i].match(/\.js$/))
      eval(fs.readFileSync("./app/src/" + src_files[i], "utf-8"));
  }
  var spec_files = fs.readdirSync("./app/spec");
  for (var i=0; i<spec_files.length; i++) {
    if (spec_files[i].match(/\.js$/))
      eval(fs.readFileSync("./app/spec/" + spec_files[i], "utf-8"));
  }
  jasmineEnv.execute();
};

var runJasmineTests = function(notifications, status_reporting) {
  var existingFiles = [];
  existingFiles = existingFiles.concat(notifications.initial);
  existingFiles = existingFiles.concat(notifications.created);
  existingFiles = existingFiles.concat(notifications.modified);
  for (var i=0; i<existingFiles.length; i++) {
    if (existingFiles[i] && existingFiles[i].match(/\.js$/)) {
      executeJasmineTests(status_reporting);
      return;
    }
  }
  console.log("Not new JS files - tests not run", existingFiles);
};

var eachFile = function(files, f, status_reporting) {
  if (!files) return;
  for (var i=0; i<files.length; i++) f(files[i], status_reporting);
};

exports.autotest = function(files, status_reporting) {
  if (files.length > 0) {
      eachFile(files, compile, status_reporting);
  } else {
    filescanner.scan(".", function(notifications) {
      eachFile(notifications.initial, compile, status_reporting);
      eachFile(notifications.created, compile, status_reporting);
      eachFile(notifications.modified, compile, status_reporting);
      eachFile(notifications.deleted, deleteCompiledFile, status_reporting);
      runJasmineTests(notifications, status_reporting);
    });
  }
};


