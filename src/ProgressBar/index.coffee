dom        = require 'stout/common/utilities/dom'
err        = require 'stout/common/err'
Component  = require './../common/Component'
Tweenable  = require 'shifty'
transform  = require './../common/transform'


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
    # Sets the label of the progress bar.
    #
    # @param {number} p - Progress value between 0 and 1.
    #
    # @todo Should throw ValueErr for numbers outside of the range [0..1]
    #
    # @setter

    set: (t) ->
      @select('.sc-progress-label')?.textContent = t


    ##
    # Returns the current label of the progress bar.
    #
    # @getter

    get: ->
      @select('.sc-progress-label')?.textContent


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
  # @param {Object} [_opts={}] - Options.
  #
  # @param {string} [_opts.type='circle'] - Progress bar type.
  #
  # @param {boolean} [_opts.numeric=false] - Show numeric progress, or not.
  #
  # @todo This should throw a ValueErr if passed an invalid progress bar type.
  #
  # @constructor

  constructor: (model, @_opts = {}) ->
    @_opts.type    or= 'circle'
    @_opts.time    or= 4000
    @_opts.numeric or= true
    tmpl = templates[@_opts.type]
    @_labelTween = new Tweenable
    @_rotationTween = new Tweenable
    @_stopRotation = false
    super(tmpl, model, {renderOnChange: false})
    @model.on 'change:progress', (e) =>
      @_setProgress(e.data.old, e.data.value)



  spin: ->
    x = transform(@select('svg'))
    @_stopRotation = false
    @_rotationTween.tween {
      from:       {turn: 0}
      to:         {turn: 1}
      duration:   800
      easing:     'easeInOutSine'
      step:       (s) -> x.rotate(s.turn + 'turn')
      finish:     => @spin() unless @_stopRotation
    }


  stop: ->
    @_stopRotation = true
    #@_rotationTween.stop true


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
    @_setProgress(0, @model.progress)


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

  _tweenLabel: (from, to, t) ->
    if not @_opts.numeric then return
    @_labelTween.stop()
    @_labelTween.tween {
      from:       {progress: from}
      to:         {progress: to}
      duration:   t
      easing:     'easeOutQuart'
      step:       (s) => @label = Math.floor(s.progress * 100)
    }


  ##
  # Sets the progress of the progress bar.
  #
  # @param {number} p - The value to set the progress bar to, a number in the
  # range [0..1].
  #
  # @method _setProgress
  # @protected

  _setProgress: (from, to) ->
    if not @rendered then return

    # Calculate the transition time. The `Math.max()` call ensures we have a
    # minimum transition time of 1/5 of the full time. This prevents super-fast
    # jump transitions when moving a relatively small amount.
    t = Math.max(0.2, Math.abs(from - to)) * @_opts.time

    # Tween the percentage label.
    @_tweenLabel from, to, t

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
    path.style.strokeDashoffset = Math.ceil(100 - to * 100) / 100 * length
