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


# The port to run the test server on.
TEST_SERVER_PORT = 8000


# Glob pattern for Jade template files.
JADE_GLOB = './src/**/[!_]*.jade'


# Glob pattern for test Jade template files.
TEST_JADE_GLOB = './test/**/[!_]*.jade'


# Glob pattern for CoffeeScript source files.
COFFEE_GLOB = './src/**/*.coffee'


# Glob pattern for test CoffeeScript files.
TEST_COFFEE_GLOB = './test/**/*.coffee'


# Glob pattern for source SASS files.
SASS_GLOB = './src/!(common)/*.sass'


# Glob pattern for test SASS files.
TEST_SASS_GLOB = './test/!(common)/*.sass'


# Glob pattern for bundling test files.
TEST_BUNDLE_GLOB = './**/demo.js'


# Compiles the passed glob with SASS.
compileSass = (glob, dest = './') ->
  gulp.src glob
    .pipe sourcemaps.init()
    .pipe sass(includePaths: ['./lib']).on('error', sass.logError)
    .pipe sourcemaps.write()
    .pipe gulp.dest dest


# Compiles the passed glob with CoffeeScript.
compileCoffee = (glob, dest = './') ->
  gulp.src glob
    .pipe sourcemaps.init()
    .pipe coffee(bare: true).on('error', gutil.log)
    .pipe sourcemaps.write()
    .pipe gulp.dest dest


# Runs coffeelint on the passed glob.
coffeeLint = (glob) ->
  gulp.src glob
    .pipe coffeelint()
    .pipe coffeelint.reporter()


# Builds test HTML pages.
gulp.task 'compile:pages:test', ->
  gulp.src TEST_JADE_GLOB
    .pipe jade()
    .pipe gulp.dest './test'


# Runs coffeelint on all CoffeeScript files.
gulp.task 'coffeelint', ->
  coffeeLint COFFEE_GLOB


# Runs coffeelint on all test CoffeeScript files.
gulp.task 'coffeelint:test', ->
  coffeeLint TEST_COFFEE_GLOB


# Compiles template Jade files.
gulp.task 'compile:templates', ->
  gulp.src JADE_GLOB
    .pipe jade(client: true)
    .pipe insert.prepend 'jade = require("jade/runtime");\n'
    .pipe insert.append '\nmodule.exports = template'
    .pipe gulp.dest './'


# Compiles all CoffeeScript.
gulp.task 'compile:coffee', ['coffeelint'], ->
  compileCoffee COFFEE_GLOB


# Compiles test CoffeeScript.
gulp.task 'compile:coffee:test', ['coffeelint'], ->
  compileCoffee TEST_COFFEE_GLOB, './test'


# Copies the SASS source files from the src folder to the corresponding
# folder at the package root.
gulp.task 'copy:sass', ->
  gulp.src ['./src/**/*.sass', './src/**/*.scss']
    .pipe gulp.dest './'


# Compiles source SASS files to CSS and places the output in the corresponding
# folder at the package root.
gulp.task 'compile:sass', ['copy:sass'], ->
  compileSass SASS_GLOB


# Compiles test SASS files.
gulp.task 'compile:sass:test', ['copy:sass'], ->
  compileSass TEST_SASS_GLOB, './test'


# Bundles test JavaScript files.
gulp.task 'bundle', [
  'compile:coffee'
  'compile:coffee:test'
  'compile:templates'
  ], (cb) ->
  glob TEST_BUNDLE_GLOB, (err, files) ->
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
  server = gls.static './', TEST_SERVER_PORT
  server.start()


# Watches all files and runs 'build:test' whenever a change is observed.
gulp.task 'watch', ->
  gulp.watch [
    COFFEE_GLOB
    SASS_GLOB
    JADE_GLOB
    TEST_JADE_GLOB
    TEST_COFFEE_GLOB
    TEST_SASS_GLOB
  ], ['build:test']


# Cleans the package.
gulp.task 'clean', ->
  del.sync([
    './!(src|test|lib|node_modules)/'
    './test/**/*.html'
    './test/**/*.js'
    './test/**/*.css'
  ])


# Builds the package.
gulp.task 'build', [
  'clean'
  'compile:coffee'
  'compile:sass'
  'compile:templates'
  ]


# Builds the package for testing.
gulp.task 'build:test', [
  'clean'
  'compile:sass'
  'compile:sass:test'
  'compile:pages:test'
  'bundle'
  ]
