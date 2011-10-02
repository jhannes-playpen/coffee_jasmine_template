var result = {
  compilationFailed: [ 'src/hello.coffee', 'spec/hello_spec.coffee' ]
};


(function() {
  var body = document.getElementsByTagName("body")[0];
  if (result.compilationFailed ) { 
    var message  = "<p>Failed to compile the following:</p><ul>";
    for (var i=0; i<result.compilationFailed.length; i++ ) {
      message += "<li>" + result.compilationFailed[i] + "</li>";     
    }
    message += "</ul>";
    var errorMessage = document.createElement("div");
    errorMessage.innerHTML = message;
    body.appendChild(errorMessage);
  }
})();
