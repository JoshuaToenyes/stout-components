_         = require 'lodash'
fs        = require 'fs'
path      = require 'path'
parsePath = require 'parse-filepath'

excludeDirs = ['common']

demos =
  jade:       {}
  coffee:     {}
  browserify: {}
  sass:       {}

components =
  jade:   {}
  coffee: {}
  sass:   {}

componentsDirs = []

addFile = (file) ->
  info = parsePath file
  # calculate path to where file should go
  destDir = path.relative __dirname, info.dirname.replace('src/', '')
  destName = path.join(destDir, info.name)

  if destDir not in componentsDirs then componentsDirs.push destDir

  # Handle demo files a little differently...
  if info.name is 'demo'
    switch info.extname
      when '.coffee'
        destName = destName + '.js'
        demos.coffee[destName] = [file]
        demos.browserify[destName] = [destName]
      when '.jade'
        demos.jade[destDir] = [file]
      when '.sass'
        demos.sass[destName + '.css'] = [file]
      else
        throw new Error "Sorry! I don't know how to handles #{file}!"

  else
    switch info.extname
      when '.coffee'
        components.coffee[destName + '.js'] = [file]
      when '.jade'
        components.jade[destDir] = [file]
      when '.sass'
        components.sass[destName + '.css'] = [file]
      else
        throw new Error "Sorry! I don't know how to handles #{file}!"

parseSources = (dir) ->
  _.each fs.readdirSync(dir), (item) ->
    item = path.join(dir, item)
    stat = fs.statSync item
    if stat.isDirectory()
      parseSources(dir)
    else
      addFile item

# Read each directory in `src`, and parse it's contents for each type of
# item to compile, copy, etc.
_.each fs.readdirSync('src'), (item) ->
  fullPath = path.join(__dirname, 'src/', item)
  stat = fs.statSync fullPath
  if stat.isDirectory() and item not in excludeDirs
    parseSources(fullPath)



module.exports = (grunt) ->

  config =


    pkg: (grunt.file.readJSON('package.json'))


    jade:
      demos:
        options:
          client: false
        files: demos.jade
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
        files: components.jade


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
        files: components.coffee
      demos:
        files: demos.coffee


    browserify:
      app:
        files: demos.browserify


    sass:
      demo:
        options:
          loadPath: 'lib/'
        files: demos.sass


    # Watch task....
    watch:

      sass:
        files: ['src/**/*.sass']
        tasks: ['sass']

      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffeelint', 'coffee', 'browserify']

      jade:
        files: ['src/**/*.jade']
        tasks: ['jade']



    connect:
      server:
        options:
          port: 8000
          base: './'


    clean:
      common: ['common']
      components: componentsDirs


    copy:
      components:
        files: components.sass


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
