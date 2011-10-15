# CoffeeScript + Jasmine autotest rig

A template project for working with CoffeeScript and Jasmine.
Compiles .coffee files automatically with node.js and runs Jasmine
with node.js. Also supports client-side Jasmine with SpecRunner.html

To get started:

* node autotest-gmessage (for Ubuntu Gmessage style notification)
* Add spec/xxx_spec.coffee 
  * autotest automatically creates xxx_spec.js
  * autotest automatically runs xxx_spec.js with Jasmine (with node)
* Add src/xxx.coffee
  * autotest automatically creates xxx.js
  * autotest reruns all tests
* Add src/xxx.js and spec/xxx_spec.js to SpecRunner.html
* Open SpecRunner.html in a web browser
  * Jasmine automatically runs all your test



