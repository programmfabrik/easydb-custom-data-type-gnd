The plugin is written in CoffeeScript, located in directory `scr/webfrontend/`.

Please try to respect <https://github.com/polarmobile/coffeescript-style-guide>.

Unit tests in directory `test` are written with Jasmine in CoffeeScript. 

Each test must have file name with extension `.test.coffee`. These files are
mapped to `.spec.coffee` files that include mockup code (`mock.coffee`) and the
plugin code.

To install CoffeeScript and Jasmine into `node_modules`, run:

    npm install

To run unit tests, run any of:

    npm test
    make test

