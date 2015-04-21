DEMOS =
  JADE:
    'button': ['src/button/demo.jade']
    'progress-button': ['src/progress-button/demo.jade']

  COFFEE:
    'button/demo.js': ['src/button/demo.coffee']
    'progress-button/demo.js': ['src/progress-button/demo.coffee']

  BROWSERIFY:
    'button/demo.js': ['button/demo.js']
    'progress-button/demo.js': ['progress-button/demo.js']

  SASS:
    'button/demo.css': ['src/button/demo.sass']
    'progress-button/demo.css': ['src/progress-button/demo.sass']


COMPONENTS =

  JADE:
    'button': ['src/button/template.jade']
    'progress-button': ['src/progress-button/template.jade']

  COFFEE:
    'button/index.js': ['src/button/index.coffee']
    'progress-button/index.js': ['src/progress-button/index.coffee']

  SASS:
    'button/demo.sass': ['src/button/demo.sass']
    'progress-button/demo.sass': ['src/progress-button/demo.sass']




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
      common:
        expand: true
        flatten: false
        cwd: 'src/common'
        src: ['./**/*.coffee']
        dest: 'common'
        ext: '.js'
      components:
        files: COMPONENTS.COFFEE
      demos:
        files: DEMOS.COFFEE


    browserify:
      app:
        files: DEMOS.BROWSERIFY


    sass:
      components:
        options:
          loadPath: 'lib/'
        files: COMPONENTS.SASS
      demo:
        options:
          loadPath: 'lib/'
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


    copy:
      components:
        files: COMPONENTS.SASS


    open:
      test:
        path: 'http://localhost:8000/index.html'
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
    'copy'
    ]

  grunt.registerTask 'demo', [
    'open'
    'connect:server:keepalive'
  ]
