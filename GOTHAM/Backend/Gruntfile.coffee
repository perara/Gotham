module.exports = (grunt)->
  grunt.loadNpmTasks('grunt-contrib-yuidoc');

  grunt.initConfig

    yuidoc:
      compile:
        name: "Gotham Backend"
        description: 'Gotham Backend Documentation'
        version: '1.0'
        url: 'http://gotham.no'
        options:
          paths: 'node_modules/'
          themedir: 'node_modules/yuidoc-bootstrap-theme'
          helpers: 'node_modules/yuidoc-bootstrap-theme/helpers/helpers.js'
          exclude: "node_modules",
          outdir: 'docs'



  grunt.registerTask 'default', ['yuidoc']
