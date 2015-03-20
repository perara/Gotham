module.exports = (grunt)->
  require('grunt-jsdoc-plugin')
  require('load-grunt-tasks') grunt

  grunt.loadNpmTasks('grunt-codo');

  grunt.initConfig
    codo:
      options:
        name: "Gotham Game Framework"
        title: "Gotham Game Framwork API Documentation"
        extra: ["LICENSE-MIT"]
      src: ["./src/GOTHAM-GF/Gotham.coffee"]
      dest: "./doc"


    jsdoc: 
      dist:
        src: [
          'src/*.js'
          'test/*.js'
        ]
        dest: 'doc'
  
    browserify:
      dist:
        files: 'htdocs/build/main.js': 'src/GOTHAM-GAME/main.coffee'
        options:
          transform: ['coffeeify']

    uglify:
      dist:
        files: 'htdocs/build/main.min.js': 'htdocs/build/main.js'

    watch:
      coffee:
        files: [
          'src/**/*.coffee',
          'src/**/*.js',
          'htdocs/*.html',
          'htdocs/assets/**/*.css',
          'htdocs/assets/**/*.png']
        tasks: ['build']
        options:
          livereload: 1337

    connect:
      server:
        options:
          open: yes
          base: "htdocs"
          port: 9001
          #hostname: 'localhost'

    clean: dist: files: 'build'

  grunt.registerTask 'build', ['clean', 'browserify'] # 'uglify'
  grunt.registerTask 'codo', ['codo']
  grunt.registerTask 'default', ['build', 'connect', 'watch']
