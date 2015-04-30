dom        = require 'stout/common/utilities/dom'
err        = require 'stout/common/err'
Component  = require './../common/Component'
Tweenable  = require 'shifty'

# Progress bar templates.
templates =
  'circle': require './circle'


##
# Simple button component which
#
module.exports = class ProgressBar extends Component

  ##
  # The progress bar label. Extending classes could override the setter and
  # getter set the label to something other than the percentage
  #
  # @property label
  # @public

  @property 'label',

    ##
    # Sets the label of the progress bar. This property assumes the value of
    # the entire label is passed, including the symbol if configured. The
    # symbol is then extract and placed in the correct HTML element within the
    # progress bar.
    #
    # @param {number} p - Progress value between 0 and 1.
    #
    # @todo Should throw ValueErr for numbers outside of the range [0..1]
    #
    # @setter

    set: (t) ->
      if not t then return
      if @model.symbol
        s = t.slice -@model.symbol.length
        t = t.slice 0, -@model.symbol.length
      else
        s = ''
      @select('.sc-progress')?.textContent = t
      @select('.sc-progress-symbol')?.textContent = s


    ##
    # Returns the current label of the progress bar.
    #
    # @getter

    get: ->
      @select('.sc-progress')?.textContent +
        @select('.sc-progress-symbol')?.textContent


  ##
  # The button progress, a floating point number between `0` and `1`.
  #
  # @todo Should throw a ValueErr if passed a number outside of the range [0, 1]
  #
  # @property {number} progress
  # @public

  @property 'progress',
    set: (p) ->
      @_setProgress(p)
      p


  ##
  # This property is `true` if the button is currently visible.
  #
  # @property {boolean} visible
  # @override
  # @public

  @property 'visible',
    get: ->
      not dom.hasClass @select('.sc-progress-bar'), 'sc-hidden'
    set: (visible) ->
      if visible then @show() else @hide()


  ##
  # This property is `true` if the button is currently hidden.
  #
  # @property {boolean} hidden
  # @override
  # @public

  @property 'hidden',
    get: ->
      not @visible
    set: (hidden) ->
      @visible = not hidden


  ##
  # ProgressBar constructor.
  #
  # @param {Object} [opts={}] - Options.
  #
  # @param {number} [opts.init=0] - Initial progress between 0 and 1.
  #
  # @param {string} [opts.type='circle'] - Progress bar type.
  #
  # @param {boolean} [opts.numeric=false] - Show numeric progress, or not.
  #
  # @param {boolean} [opts.symbol='%'] - The percentage symbol to use. (Set to
  # the empty string for no symbol.)
  #
  # @todo This should throw a ValueErr if passed an invalid progress bar type.
  #
  # @constructor

  constructor: (opts={}) ->
    opts.init    or= 0
    opts.type    or= 'circle'
    opts.time    or= 4000
    opts.numeric or= false
    opts.symbol  ?= if opts.numeric then '%' else ''
    tmpl = templates[opts.type]
    @_labelTween = new Tweenable
    super(tmpl, opts, {renderOnChange: false})


  spin: ->
    dom.addClass @select('svg'), 'sc-anim-spin'
    dom.removeClass @select('svg'), 'sc-anim-stop-spin'


  stop: ->
    dom.addClass @select('svg'), 'sc-anim-stop-spin'
    dom.removeClass @select('svg'), 'sc-anim-spin'


  ##
  # Shows the progress bar.
  #
  # @method show
  # @override
  # @public

  show: ->
    if @rendered then dom.removeClass @select('.sc-progress-bar'), 'sc-hidden'


  ##
  # Hides the progress bar.
  #
  # @method hide
  # @override
  # @public

  hide: ->
    if @rendered then dom.addClass @select('.sc-progress-bar'), 'sc-hidden'


  ##
  # Renders the progress bar and sets its initial value.
  #
  # @method render
  # @override
  # @public

  render: ->
    super()
    @progress = 0
    @progress = @model.init


  ##
  # Returns the svg path of the progress bar.
  #
  # @method _getPath
  # @private
  _getPath: ->
    @el.getElementsByTagName('path')[0]


  ##
  # Tweens the percentage label to the specified percentage.
  #
  # @param {number} p - The percentage value to tween to in the range [0..1]
  #
  # @param {number} t - The amount of time (in milliseconds) to tween.
  #
  # @method _tweenLabel
  # @private

  _tweenLabel: (p, t) ->
    if not @model.numeric then return
    @_labelTween.stop()
    current = @_labelTween.get()?.progress or @_progress or 0
    @_labelTween.tween {
      from:       {progress: current}
      to:         {progress: p}
      duration:   t
      easing:     'easeOutQuart'
      step:       (v) => @label = Math.floor(v.progress * 100) + @model.symbol
    }


  ##
  # Sets the progress of the progress bar.
  #
  # @param {number} p - The value to set the progress bar to, a number in the
  # range [0..1].
  #
  # @method _setProgress
  # @protected

  _setProgress: (p) ->
    if not @rendered then return

    # Stop if the progress is the same (or the animation to it is already in
    # progress).
    if p is @_progress then return

    # Calculate the transition time. The `Math.max()` call ensures we have a
    # minimum transition time of 1/5 of the full time. This prevents super-fast
    # jump transitions when moving a relatively small amount.
    t = Math.max(0.2, Math.abs(@_progress - p)) * @model.time

    # Tween the percentage label.
    @_tweenLabel p, t

    # Set the progress (this must be done after the call to `_tweenLabel()`
    # since it depends on the current progress value).
    @_progress = p

    # Grab reference to the SVG's path.
    path = @_getPath()
    length = path.getTotalLength()

    # Set up the starting positions
    path.style.strokeDasharray = length + ' ' + length
    path.style.strokeDashoffset = length

    # Trigger a layout so styles are calculated & the browser picks up the
    # starting position before animating.
    path.getBoundingClientRect()

    # Set style the transition time.
    path.style.transitionDuration = path.style.webkitTransitionDuration =
      "#{t}ms"

    # Set the path length. The extra math ensures that we only increment in
    # increments of 0.01 (or 1%). This prevents the bar showing some progress
    # (like at 0.5%) while the label still indicates 0%... or the bar being
    # visually full (like at 99.99%) while the label indicates only 99%.
    path.style.strokeDashoffset = Math.ceil(100 - p * 100) / 100 * length
