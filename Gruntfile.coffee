module.exports = (grunt) ->

  grunt.initConfig
    watch:
      emberTemplates:
        files: 'app/assets/templates/**/*.hbs'
        tasks: 'emberTemplates'
    emberTemplates:
      compile:
        options:
          templateNamespace: 'Handlebars'
          templateName: (sourceFile) ->
            sourceFile.replace(/app\/assets\/templates\//, '').replace(/\.hbs$/, '')
        files:
          'app/assets/js/templates.js': 'app/assets/templates/**/*.hbs'

  # Plugins.
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-ember-templates')

  # Default task.
  grunt.registerTask('default', ['emberTemplates'])