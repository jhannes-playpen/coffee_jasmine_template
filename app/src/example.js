(function() {
  exports.Example = (function() {
    function Example() {}
    Example.prototype.sayHello = function(person) {
      return "Hello " + person;
    };
    return Example;
  })();
}).call(this);
