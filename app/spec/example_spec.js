(function() {
  describe('Example project', function() {
    return it("tell hello world", function() {
      var example;
      example = new exports.Example();
      return expect(example.sayHello("Jeremy")).toEqual("Hello Jeremy");
    });
  });
}).call(this);
