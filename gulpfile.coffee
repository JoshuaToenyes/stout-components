browserify = require 'browserify'
buffer     = require 'vinyl-buffer'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
del        = require 'del'
glob       = require 'glob'
gls        = require 'gulp-live-server'
gulp       = require 'gulp'
gutil      = require 'gulp-util'
insert     = require 'gulp-insert'
jade       = require 'gulp-jade'
sass       = require 'gulp-sass'
source     = require 'vinyl-source-stream'
sourcemaps = require 'gulp-sourcemaps'
uglify     = require 'gulp-uglify'


JADE_GLOB = './src/**/!(demo).jade'


DEMO_JADE_GLOB = ['./src/**/demo.jade', './src/*.jade']


COFFEE_GLOB = './src/**/!(demo).coffee'


DEMO_COFFEE_GLOB = './src/**/demo.coffee'


SASS_GLOB = './src/!(common)/!(demo).sass'


DEMO_SASS_GLOB = './src/!(common)/demo.sass'


DEMO_BUNDLE_GLOB = './**/demo.js'


compileSass = (glob) ->
  gulp.src glob
    .pipe sourcemaps.init()
    .pipe sass(includePaths: ['./lib']).on('error', sass.logError)
    .pipe sourcemaps.write()
    .pipe gulp.dest './'


compileCoffee = (glob) ->
  gulp.src glob
    .pipe sourcemaps.init()
    .pipe coffee(bare: true).on('error', gutil.log)
    .pipe sourcemaps.write()
    .pipe gulp.dest './'


coffeeLint = (glob) ->
  gulp.src glob
    .pipe coffeelint()
    .pipe coffeelint.reporter()


gulp.task 'compile:demo:pages', ->
  gulp.src DEMO_JADE_GLOB
    .pipe jade()
    .pipe gulp.dest './'


gulp.task 'coffeelint', ->
  coffeeLint COFFEE_GLOB


gulp.task 'coffeelint:demo', ->
  coffeeLint DEMO_COFFEE_GLOB


gulp.task 'compile:templates', ->
  gulp.src JADE_GLOB
    .pipe jade(client: true)
    .pipe insert.prepend 'jade = require("jade/runtime");\n'
    .pipe insert.append '\nmodule.exports = template'
    .pipe gulp.dest './'


gulp.task 'compile:coffee', ['coffeelint'], ->
  compileCoffee COFFEE_GLOB


gulp.task 'compile:demo:coffee', ['coffeelint'], ->
  compileCoffee DEMO_COFFEE_GLOB


gulp.task 'compile:sass', ->
  compileSass SASS_GLOB


gulp.task 'compile:demo:sass', ->
  compileSass DEMO_SASS_GLOB


gulp.task 'bundle', [
  'compile:coffee'
  'compile:demo:coffee'
  'compile:templates'], (cb) ->
  glob DEMO_BUNDLE_GLOB, (err, files) ->
    if err
      gutil.log err
    else
      files.forEach (file) ->
        b = browserify
          entries: file
          debug: true
        b.bundle()
          .pipe source file
          .pipe buffer()
          .pipe sourcemaps.init loadMaps: true
          .pipe sourcemaps.write()
          .pipe gulp.dest './'
    cb()


gulp.task 'serve', ->
  server = gls.static './', 8000
  server.start()
  # gulp.watch [
  #   './!(node_modules)/*.css'
  #   './!(node_modules)/*.html'
  #   './!(node_modules)/*.js'], ->
  #   server.notify.apply(server, arguments)


gulp.task 'watchit', ->
  gulp.watch [
    COFFEE_GLOB
    SASS_GLOB
    JADE_GLOB
    DEMO_JADE_GLOB
    DEMO_COFFEE_GLOB
    DEMO_SASS_GLOB
  ], ['build:demo']


gulp.task 'clean', ->
  del.sync([
    './!(src|test|lib|node_modules)/'
    './*.html'
    './*.js'
  ])


gulp.task 'build', [
  'clean'
  'compile:coffee'
  'compile:sass'
  'compile:templates'
  ]


gulp.task 'build:demo', [
  'clean'
  'compile:sass'
  'compile:demo:sass'
  'compile:demo:pages'
  'bundle'
  ]
