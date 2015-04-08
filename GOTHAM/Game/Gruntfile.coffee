module.exports = (grunt)->
  require('grunt-jsdoc-plugin')
  require('load-grunt-tasks') grunt

  grunt.loadNpmTasks('grunt-codo');

  grunt.initConfig
    browserify:
      dist:
        files: 'htdocs/build/GothamGame.js': 'src/main.coffee'
        options:
          transform: ['coffeeify']

    uglify:
      dist:
        files: 'htdocs/build/GothamGame.min.js': 'htdocs/build/GothamGame.js'

    watch:
      coffee:
        files: [
          '!**/node_modules/**'
          '!**/dist/**'
          '!**/dependencies/**'

          # Include all Code Coffeescript
          'src/**/*.coffee',

          # Include all framework stuff
          '../GameFramework/src/**/*.coffee'

          'htdocs/*.html',
          'htdocs/assets/**/*.css',
          'htdocs/assets/**/*.png']
        tasks: ['build']
        options:
          livereload: 1337

    connect:
      server:
        options:
          open: false
          base: "htdocs"
          port: 9001
          #hostname: 'localhost'

    clean: dist: files: 'build'

  grunt.registerTask 'build', ['browserify'] # 'uglify'
  grunt.registerTask 'codo', ['codo']
  grunt.registerTask 'default', ['build', 'connect', 'watch']
