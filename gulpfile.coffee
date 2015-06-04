browserify = require 'browserify'
buffer     = require 'vinyl-buffer'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
del        = require 'del'
gcb        = require 'gulp-callback'
glob       = require 'glob'
gls        = require 'gulp-live-server'
gulp       = require 'gulp'
gutil      = require 'gulp-util'
insert     = require 'gulp-insert'
jade       = require 'gulp-jade'
karma      = require 'gulp-karma'
rename     = require 'gulp-rename'
sass       = require 'gulp-sass'
source     = require 'vinyl-source-stream'
sourcemaps = require 'gulp-sourcemaps'
uglify     = require 'gulp-uglify'


# The port to run the test server on.
TEST_SERVER_PORT = 8000


# Glob pattern for Jade template files.
TEMPLATES_GLOB = './src/**/[!_]*.jade'


# Glob pattern for test Jade template files.
TEST_JADE_GLOB = './test/**/[!_]*.jade'


# Glob pattern for CoffeeScript source files.
COFFEE_GLOB = './src/**/*.coffee'


# Glob pattern for test CoffeeScript files.
TEST_COFFEE_GLOB = './test/**/*.coffee'


# Files matching this pattern will be run as tests with Karma.
KARMA_TESTS_GLOB = ['./test/**/*-test-bundle.js', './test/**/*.css']


# Glob pattern for source SASS files.
SASS_GLOB = './src/!(common)/*.sass'


# Glob pattern for test SASS files.
TEST_SASS_GLOB = './test/!(common)/*.sass'


# Glob pattern for bundling test files. (Bundle all .js files in the test
# directory except already-bundled files.)
TEST_BUNDLE_GLOB = './test/**/*[!-bundle].js'


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


runKarma = (glob, singleRun = true) ->
  opts =
    configFile: 'karma.conf.coffee'
    action: if singleRun then 'run' else 'watch'
  gulp.src KARMA_TESTS_GLOB
    .pipe karma(opts)


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
  gulp.src TEMPLATES_GLOB
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
gulp.task 'bundle:test', [
  'compile:templates'
  'compile:coffee'
  'compile:coffee:test'
  ], (done) ->
  glob TEST_BUNDLE_GLOB, (err, files) ->
    if err
      gutil.log err
    else
      i = 0
      cb = -> if ++i is files.length then done()
      files.forEach (file) ->
        b = browserify
          entries: file
          debug: true
        b.bundle()
          .pipe source file
          .pipe buffer()
          .pipe sourcemaps.init loadMaps: true
          .pipe sourcemaps.write()
          .pipe rename((p) -> p.basename += '-bundle')
          .pipe gulp.dest './'
          .pipe gcb(cb)


gulp.task 'serve', ->
  server = gls.static './', TEST_SERVER_PORT
  server.start()


gulp.task 'test', ['build:test'], ->
  runKarma KARMA_TESTS_GLOB, true


gulp.task 'karma', ->
  runKarma KARMA_TESTS_GLOB, false


# Watches files and re-compiles as needed.
gulp.task 'watch', ->

  # Watch all CoffeeScript files, when they change re-bundle the tests.
  gulp.watch [
    COFFEE_GLOB
    TEST_COFFEE_GLOB
    TEMPLATES_GLOB
  ], ['bundle:test']

  # Recompile SASS files when they change.
  gulp.watch [
    SASS_GLOB
  ], ['compile:sass']

  # Recompile test SASS files when they change.
  gulp.watch [
    TEST_SASS_GLOB
  ], ['compile:sass:test']

  # Recompile test pages when they change.
  gulp.watch [
    TEST_JADE_GLOB
  ], ['compile:pages:test']


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
  'bundle:test'
  ]
