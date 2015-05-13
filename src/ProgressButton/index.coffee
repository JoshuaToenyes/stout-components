dom        = require 'stout/common/utilities/dom'
template   = require './template'
Button     = require './../button'


##
# Simple button component which
#
module.exports = class ProgressButton extends Button

  ##
  # The button progress, a floating point number between `0` and `1`.
  #
  # @property {number} progress
  # @public

  @property 'progress',
    set: (p) ->
      return p


  ##
  # This property is `true` if the button is currently visible, or filled.
  #
  # @property {boolean} visible
  # @override
  # @public

  @property 'visible',
    set: (visible) ->
      if visible then @show() else @hide()
    get: ->
      dom.hasClass @_getButton(), 'sc-fill'


  ##
  # ProgressButton constructor.
  #
  # @param {string} [label='Button'] - The initial button label.
  #
  # @constructor

  constructor: (label = 'Progress Button') ->
    super(label)
    @template = template


  spin: ->
    @disabled = true
    dom.addClass @_getButton(), 'sc-progress-button-contract'


  stop: ->
    @disabled = false
    dom.removeClass @_getButton(), 'sc-progress-button-contract'


  ##
  # Shows the button by filling the background.
  #
  # @method show
  # @override
  # @public

  show: ->
    super()


  ##
  # Hides the button.
  #
  # @method hide
  # @override
  # @public

  hide: ->
    super()


  ##
  # Removes the fill from the button and shows the progress bar.
  #
  # @method showProgressBar
  # @public

  showProgressBar: ->
    @_unfill()
    dom.addClass(@_getButton(), 'sc-show-path')


  ##
  # Hides the progress bar and fills the button.
  #
  # @method hideProgressBar
  # @public

  hideProgressBar: ->
    @_fill()
    dom.removeClass(@_getButton(), 'sc-show-path')


  ##
  # Returns the svg path of the progress bar.
  #
  # @method _getPath
  # @private
  _getPath: ->
    @el.getElementsByTagName('path')[0]


  ##
  # Sets the progress
  setProgress: (p) ->
    path = @_getPath()
    length = path.getTotalLength()

    # Set up the starting positions
    path.style.strokeDasharray = length + ' ' + length
    path.style.strokeDashoffset = length

    # Trigger a layout so styles are calculated & the browser picks up the
    # starting position before animating
    path.getBoundingClientRect()

    path.style.transition = path.style.WebkitTransition =
      'stroke-dashoffset 2s ease-in-out';

    path.style.transitionDuration = path.style.webkitTransitionDuration =
      (p * 2) + 's'

    path.style.strokeDashoffset = (1 - p) * length
