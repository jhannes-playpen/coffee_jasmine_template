var autotest = require('./autotest').autotest;


var notifyError = function(title, message) {
  console.error(title, message);
};

var notifyOk = function(title, message) {
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
    notifyOk("Recompiled", message);
  },
  upload_complete : function(message) {
    notifyOk("Upload complete", message);
  },
  upload_failure : function(message) {
    notifyError("Upload failed", message);
  }
};


files = process.argv.slice(2);

autotest(files, status_reporting);

