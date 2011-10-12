var autotest = require('./autotest').autotest;
var growl = require('./build/notify-send');

var notifyError = function(title, message) {
  growl.timeout(100).icon(process.cwd() + "/build/Actions-window-close-icon.png").
	  notify(title, message.replace(/'/g, '"'));
  console.error("failed to compile", title, message);
};

var notifyOk = function(title, message) {
  growl.timeout(100).icon(process.cwd() + "/build/Actions-dialog-ok-apply-icon.png").
  	notify(title, message.replace(/'/g, '"'));
  console.log(title, message);
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

