var fs = require("fs"),
    filescanner = require("./filescanner"),
    coffee = require('./build/coffee-script'),
    exec = require('child_process').exec
    ;

var compileCoffee = function(coffee_file) {
  var js_file = coffee_file.replace(/\.coffee$/, ".js")
  //if (fs.statSync(coffee_file).mtime <= fs.statSync(js_file).mtime) return;
  console.log("compiling", coffee_file);
  fs.unlink(js_file, function() {
    try {
      var js_src = coffee.CoffeeScript.compile(fs.readFileSync(coffee_file, "utf8"));
      fs.writeFileSync(js_file, js_src, "utf8");
    } catch (err) {
      console.error("failed to compile", coffee_file, ":", err);
    }
  });
}
    
var compile = function(file) {
  if ( file.match(/.coffee$/) ) compileCoffee(file);
};

var deleteCompiledFile = function(original) {
  if ( original.match(/.coffee$/) ) {
    var js_file = original.replace(/\.coffee$/, ".js")
    console.log("deleting", js_file);
    fs.unlinkSync(js_file);
  }
};

var eachFile = function(files, f) {
  if (!files) return;
  for (var i=0; i<files.length; i++) f(files[i]);
};


files = process.argv.slice(2);
if (files.length > 0) {
    eachFile(files, compile);
} else {
  filescanner.scan(".", function(notifications) {
    eachFile(notifications.initial, compile);
    eachFile(notifications.created, compile);
    eachFile(notifications.modified, compile);
    eachFile(notifications.deleted, deleteCompiledFile);
  });
}

