##
# Defines the Console component class, which is a simple console-like
# text-output component.

template    = require './template'
Output      = require './../common/Output'



##
# Masked text input.
#
# @class MaskedTextInput

module.exports = class Console extends Output

  ##
  # The name of the property on the model which contains the output which
  # should be renderd.
  #
  # @property field
  # @type string
  # @public

  @property 'field',
    required: true


  ##
  # If set to `true`, the console will automatically scroll down to new entries
  # as they arive, if the window is scrolled withing `threshold` pixels of the
  # bottom of the console window.
  #
  # @property autoScroll
  # @type boolean
  # @public

  @property 'autoScroll',
    default: true


  ##
  # The number of pixels that the scroll window must be within in-order to
  # trigger auto-scrolling (if it is enabled).
  #
  # @property threshold
  # @type number
  # @public

  @property 'threshold',
    default: 100


  ##
  # MaskedTextInput constructor.
  #
  # @constructor

  constructor: (model, init = {}) ->
    super template, model, {renderOnChange: false}, init

    ##
    # The currently rendered content.
    #
    # @property _currentValue
    # @type string
    # @private

    @_currentValue = model[@field] or ''

    model.on "change:#{@field}", (e) =>
      @_updateView e.data.value


  ##
  # Updates the view by adding the difference between what is currently
  # rendered and the model. This, in combination with adding a new `span`
  # tag for each update, ensures that the currently rendered contents remains
  # selectable between updates. If the currently rendered contents is not a
  # subset of the updated model's contents, the output is completely
  # re-rendered.
  #
  # @param {string} v - Updated model contents.
  #
  # @method _updateView
  # @private

  _updateView: (v) ->
    if not @rendered then return
    pre = @select('pre')

    # Grab the current content and use `nc` as the "new content."
    cc = @_currentValue
    nc = ''

    # Detect if we should clear the window and start-over.
    if v.length > cc.length and v.substring(0, cc.length) == cc
      nc = v.substring cc.length
    else
      pre.innerHTML = ''
      nc = v

    # Create and append a new element for the new content.
    el = document.createElement 'span'
    el.textContent = nc
    pre.appendChild el

    # Update the current value.
    @_currentValue = v

    # Measure how-close we are to the bottom of the console window.
    triggerScroll = Math.abs(
      pre.clientHeight + pre.scrollTop - pre.scrollHeight) < @threshold

    # If autoscroll is enabled, and a scroll should be triggered, then update
    # the scroll position.
    if @autoScroll and triggerScroll
      pre.scrollTop = pre.scrollHeight
