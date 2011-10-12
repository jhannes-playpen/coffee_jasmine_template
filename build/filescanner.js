exports.scan = function(directory, listener) {
  var files = fileTree(directory);
  initialScan(files, listener);
  periodicScan(files, listener);
};

var initialScan = function(fileTree, listener) {
  var initial = [];
  for (var file in fileTree) {
    initial.push(file);
  }
  listener({initial: initial});  
};

var periodicScan = function(files, listener) {
  var newFiles = fileTree(".");
  var notification = {
    created: findMissing(files, newFiles),
    deleted: findMissing(newFiles, files),
    modified: findModified(files, newFiles)
  };
  if (notification.created.length > 0 || notification.deleted.length > 0 || notification.modified.length > 0) {
    listener(notification);
    timers.setTimeout(periodicScan, 10, newFiles, listener);
  } else {
    timers.setTimeout(periodicScan, 400, newFiles, listener);
  }
};

var fs = require("fs"),
    timers = require("timers");

var fileTree = function(root) {
  var files = fs.readdirSync(root);
  var result = [];
  for (var i=0; i<files.length; i++) {
    if (files[i].match(/^\./)) {
      continue;
    }
    var filename = root + "/" + files[i];
    var stat = fs.statSync(filename);
    if (stat.isFile()) {
      result[filename] = stat.mtime;
    } else if (stat.isDirectory()) {
      var subfiles = fileTree(filename);
      for (file in subfiles) {
        result[file] = subfiles[file];
      }
    }
  }
  return result;
};

var findMissing = function(newFileTree, oldFileTree) {
  var missing = [];
  for (var file in oldFileTree) {
    if (!newFileTree[file]) missing.push(file);
  }
  return missing;
};

var findModified = function(oldFileTree, newFileTree) {
  var result = [];
  for (var file in oldFileTree) {
    if (newFileTree[file] > oldFileTree[file]) result.push(file);
  }
  return result;
};
