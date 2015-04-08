// Karma configuration
// Generated on Mon Jul 21 2014 11:48:34 GMT+0200 (CEST)
module.exports = function(config) {
    config.set({

        // base path used to resolve all patterns (e.g. files, exclude)
        basePath: '',

        // frameworks to use
        frameworks: ['mocha', 'sinon-chai'],

        // list of files / patterns to load in the browser
        files: [
            '../../htdocs/build/Gotham-dep.js',
            '../../htdocs/build/GothamGame.js',
            './src/Tests/*.coffee'
        ],

        // list of files to exclude
        exclude: ["./karma.conf.js"],

        // preprocess matching files before serving them to the browser
        preprocessors: {
            './src/Tests/*.coffee' : ['coffee']
            //'src/*.js': ['coverage']
        },

        coverageReporter: {
            type: 'text-summary',
            dir: 'coverage/'
        },

        // test results reporter to use
        reporters: ['progress', 'coverage'],

        // web server port
        port: 9876,

        // enable / disable colors in the output (reporters and logs)
        colors: true,

        // level of logging
        logLevel: config.LOG_INFO,

        // enable / disable watching file and executing tests on file changes
        autoWatch: true,

        // start these browsers
        browsers: ['PhantomJS'],

        // Continuous Integration mode
        // if true, Karma captures browsers, runs the tests and exits
        singleRun: false
    });
};