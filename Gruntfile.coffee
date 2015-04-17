DEMOS =
  JADE:
    'button': ['src/button/index.jade']

  BROWSERIFY:
    'button/demo.js': ['button/index.js']

  SASS:
    'button/demo.css': ['src/button/demo.sass']


COMPONENTS =

  JADE:
    'button': ['src/button/template.jade']

  COFFEE:
    'button/index.js': ['src/button/button.coffee']




COMPONENT_DIRS = ['button']


module.exports = (grunt) ->

  config =

    pkg: (grunt.file.readJSON('package.json'))


    jade:
      demos:
        options:
          client: false
        files: DEMOS.JADE
      index:
        options:
          client: false
        files:
          '.': ['src/index.jade']
      templates:
        options:
          client: true
          wrap:
            wrap: true
            amd: false
            node: true
            dependencies: 'jade-runtime'
          runtime: false
        files: COMPONENTS.JADE


    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app: ['src/**/*.coffee']


    coffee:
      components:
        files: COMPONENTS.COFFEE


    browserify:
      app:
        files: DEMOS.BROWSERIFY


    sass:
      components:
        files: COMPONENTS.SASS
      demo:
        files: DEMOS.SASS



    watch:
      compile:
        files: ['src/**/*.coffee', 'src/**/*.jade', 'src/**/*.sass']
        tasks: ['compile']
        configFiles:
          files: ['Gruntfile.coffee']
          options:
            reload: true


    connect:
      server:
        options:
          port: 8000
          base: './'


    clean:
      components: COMPONENT_DIRS


    open:
      test:
        path: 'http://localhost:8000/'
        app: 'Safari'


  grunt.initConfig(config)

  for pkg of config.pkg.devDependencies
    if /grunt\-/.test pkg
      grunt.loadNpmTasks pkg

  grunt.registerTask 'compile', [
    'coffeelint'
    'clean'
    'coffee'
    'jade'
    'browserify'
    'sass'
    ]

  grunt.registerTask 'demo', [
    'open'
    'connect:server:keepalive'
  ]
