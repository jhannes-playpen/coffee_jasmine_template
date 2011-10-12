var child_process = require('child_process');
var autotest = require('./autotest').autotest;

var exec = function(command) {
  console.log(command);
  child_process.exec(command);
}

var notifyError = function(title, message) {
  console.error(title, message);
  exec("gmessage --nofocus --borderless --buttons '' --geometry 500x50 --wrap --timeout 5 --bg red \"" + title + ": " + message + "\"");
};

var notifyOk = function(title, message) {
  console.log(title, message);
  exec("gmessage --nofocus --borderless --buttons '' --geometry 500x50 --wrap --timeout 3 --bg green \"" + title + ": " + message + "\"");
};

var status_reporting = {
  test_success : function(message) {
    notifyOk("Tests ok", message);
  },
  test_none_ran : function(message) {
    console.log("Not tests to run", message);
  },
  test_failures : function(message) {
    notifyError("Test failure", message);
  },
  compile_ok : function(message) {
    notifyOk("Compile ok", message);
  },
  compile_failures : function(message) {
    notifyError("failed to compile", message);
  },
  recompile_ok : function(message) {
    console.log("Recompiled", message);
  }
};


files = process.argv.slice(2);

autotest(files, status_reporting);

