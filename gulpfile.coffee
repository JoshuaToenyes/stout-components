browserify = require 'browserify'
bump       = require 'gulp-bump'
buffer     = require 'vinyl-buffer'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
del        = require 'del'
filter     = require 'gulp-filter'
gcb        = require 'gulp-callback'
git        = require 'gulp-git'
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
svg        = require 'svg-browserify'
tag        = require 'gulp-tag-version'
uglify     = require 'gulp-uglify'


# The port to run the test server on.
TEST_SERVER_PORT = 8000


# --- Jade Globs ---

# Glob pattern for Jade template files.
SRC_TEMPLATES = './src/**/[!_]*.jade'

# Glob pattern for test Jade template files.
TEST_JADE = './test/**/[!_]*.jade'

# Glob pattern for example Jade template files.
EXAMPLE_JADE = './example/**/[!_]*.jade'


# --- CoffeeScript Globs ---

# Glob pattern for CoffeeScript source files.
SRC_COFFEE = './src/**/*.coffee'

# Glob pattern for test CoffeeScript files.
TEST_COFFEE = './test/**/*.coffee'

# Glob pattern for example CoffeeScript files.
EXAMPLE_COFFEE = './example/**/*.coffee'


# --- SASS Globs ---

# Glob pattern for source SASS files.
SRC_SASS = './src/!(common)/*.sass'

# Glob pattern for test SASS files.
TEST_SASS = './test/!(common)/*.sass'

# Glob pattern for test SASS files.
EXAMPLE_SASS = './example/!(common)/*.sass'


# --- Bundle Globs ---

# Glob pattern for bundling test files. (Bundle all .js files in the test
# directory except already-bundled files.)
TEST_BUNDLE = './test/**/!(*-bundle).js'

# Glob pattern for bundling example files.
EXAMPLE_BUNDLE = './example/**/!(*-bundle).js'


# --- Test Specific Globs ---

# Files matching this pattern will be run as tests with Karma.
KARMA_TESTS = ['./test/**/*-test-bundle.js', './test/**/*.css']


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


# Runs Karma tests on the passed glob.
runKarma = (glob, singleRun = true) ->
  opts =
    configFile: 'karma.conf.coffee'
    action: if singleRun then 'run' else 'watch'
  gulp.src KARMA_TESTS
    .pipe karma(opts)


# Bundles glob-matched files using Browserify.
bundle = (glb, done) ->
  glob glb, (err, files) ->
    if err
      gutil.log err
    else
      i = 0
      cb = -> if ++i is files.length then done()
      files.forEach (file) ->
        b = browserify
          entries: file
          debug: true
          transform: svg
        b.bundle()
          .pipe source file
          .pipe buffer()
          .pipe sourcemaps.init loadMaps: true
          .pipe sourcemaps.write()
          .pipe rename((p) -> p.basename += '-bundle')
          .pipe gulp.dest './'
          .pipe gcb(cb)

bump = (importance) ->
  gulp.src './package.json'
    .pipe bump type: importance
    .pipe dest './'
    .pipe git.commit 'Bumped version number.'
    .pipe filter 'package.json'
    .pipe tag()


# Builds test HTML pages.
gulp.task 'compile-pages-tests', ->
  gulp.src TEST_JADE
    .pipe jade()
    .pipe gulp.dest './test'


# Builds example HTML pages.
gulp.task 'compile-pages-examples', ->
  gulp.src EXAMPLE_JADE
    .pipe jade()
    .pipe gulp.dest './example'


# Runs coffeelint on all CoffeeScript files.
gulp.task 'coffeelint-src', ->
  coffeeLint SRC_COFFEE


# Runs coffeelint on all test CoffeeScript files.
gulp.task 'coffeelint-tests', ->
  coffeeLint TEST_COFFEE


# Runs coffeelint on all example CoffeeScript files.
gulp.task 'coffeelint-examples', ->
  coffeeLint EXAMPLE_COFFEE


# Compiles template Jade files.
gulp.task 'compile-templates-src', ->
  gulp.src SRC_TEMPLATES
    .pipe jade(client: true)
    .pipe insert.prepend 'jade = require("jade/runtime");\n'
    .pipe insert.append '\nmodule.exports = template;'
    .pipe gulp.dest './'


# Compiles all CoffeeScript.
gulp.task 'compile-coffee-src', ['coffeelint-src', 'compile-templates-src'], ->
  compileCoffee SRC_COFFEE


# Compiles test CoffeeScript.
gulp.task 'compile-coffee-tests', ['coffeelint-tests', 'compile-coffee-src'], ->
  compileCoffee TEST_COFFEE, './test'


# Compiles example files CoffeeScript.
gulp.task 'compile-coffee-examples', ['coffeelint-examples', 'compile-coffee-src'], ->
  compileCoffee EXAMPLE_COFFEE, './example'


# Copies the SASS source files from the src folder to the corresponding
# folder at the package root.
gulp.task 'copy-sass-src', ->
  gulp.src ['./src/**/*.sass', './src/**/*.scss']
    .pipe gulp.dest './'


# Compiles test SASS files.
gulp.task 'compile-sass-tests', ['copy-sass-src'], ->
  compileSass TEST_SASS, './test'


# Compiles example SASS files.
gulp.task 'compile-sass-examples', ['copy-sass-src'], ->
  compileSass EXAMPLE_SASS, './example'


# Bundles test JavaScript files.
gulp.task 'bundle-tests', ['compile-coffee-tests'], (done) ->
    bundle(TEST_BUNDLE, done)


# Bundles example JavaScript files.
gulp.task 'bundle-examples', ['compile-coffee-examples'], (done) ->
    bundle(EXAMPLE_BUNDLE, done)


gulp.task 'serve', ->
  server = gls.static './example', TEST_SERVER_PORT
  gulp.watch [
    './example/**/*.html',
    './example/**/*.css',
    './example/**/*.js'], ->
    server.notify.apply(server, arguments)
  server.start()


# Runs a single run of the Karma tests.
gulp.task 'test', ['build-tests'], ->
  runKarma KARMA_TESTS, true


# Opens and runs Karma tests continuously.
gulp.task 'karma', ->
  runKarma KARMA_TESTS, false


# Watches files and re-compiles as required.
gulp.task 'watch', ->

  # Recompile test SASS files when they change.
  gulp.watch [TEST_SASS], ['compile-sass-tests']
  gulp.watch [EXAMPLE_SASS], ['compile-sass-examples']

  # Recompile test pages when they change.
  gulp.watch [TEST_JADE], ['compile-pages-tests']
  gulp.watch [EXAMPLE_JADE], ['compile-pages-examples']


# Watches files with the intent of running karma tests.
gulp.task 'watch-tests', ['watch'], ->
  gulp.watch [SRC_COFFEE, TEST_COFFEE, SRC_TEMPLATES], ['build-tests']


# Watches files with the intent of running the examples.
gulp.task 'watch-examples', ['watch'], ->
  gulp.watch [SRC_COFFEE, EXAMPLE_COFFEE, SRC_TEMPLATES], ['build-examples']
  gulp.watch [SRC_SASS], ['compile-sass-examples']


# Bump the patch version, commit and tag.
gulp.task 'bump-patch', -> bump 'patch'


# Bump the minor version, commit and tag.
gulp.task 'bump-minor', -> bump 'minor'


# Bump the major version, commit and tag.
gulp.task 'bump-major', -> bump 'major'


# Cleans the package.
gulp.task 'clean', ->
  del.sync([
    './!(src|test|lib|node_modules|example)/'
    './test/**/*.html'
    './test/**/*.js'
    './test/**/*.css'
    './example/**/*.html'
    './example/**/*.js'
    './example/**/*.css'
  ])


# Builds the package.
gulp.task 'build-src', ['compile-coffee-src', 'copy-sass-src']


# Builds the package for testing.
gulp.task 'build-tests', [
  'compile-sass-tests'
  'compile-pages-tests'
  'bundle-tests'
  ]


# Builds the examples.
gulp.task 'build-examples', [
  'compile-sass-examples'
  'compile-pages-examples'
  'bundle-examples'
  ]
