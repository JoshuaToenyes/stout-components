dom        = require 'stout/common/utilities/dom'
template   = require './template'
Hoverable  = require '../common/Hoverable'
Model      = require 'stout/common/model/Model'


##
# Simple button component which
#
module.exports = class Button extends Hoverable

  ##
  # The button label.
  #
  # @property {string} label
  # @public

  @property 'label',
    get: ->
      @_getButton()?.innerHTML
    set: (l) ->
      @_getButton()?.innerHTML = l


  ##
  # If the button is currently disabled.
  #
  # @property {boolean} disabled
  # @public

  @property 'disabled',
    set: (disable) ->
      if disable
        @_getButton()?.setAttribute 'disabled', 'true'
      else
        @_getButton()?.removeAttribute 'disabled'
    get: ->
      return @_getButton()?.hasAttribute 'disabled'


  ##
  # If the button is currently disabled (the inverse of disabled).
  #
  # @property {boolean} enabled
  # @public

  @property 'enabled',
    set: (enabled) ->
      @disabled = not enabled
    get: ->
      not @disabled


  ##
  # This property is `true` if the button is currently hidden, or unfilled.
  #
  # @property {boolean} hidden
  # @public

  @property 'hidden',
    set: (hidden) ->
      @visible = not hidden
    get: ->
      not @visible


  ##
  # This property is `true` if the button is currently visible, or filled.
  #
  # @property {boolean} visible
  # @public

  @property 'visible',
    set: (visible) ->
      if visible then @show() else @hide()
    get: ->
      dom.hasClass @_getButton(), 'sc-fill'


  ##
  # Button constructor.
  #
  # @param {string} [label='Button'] - The initial button label.
  #
  # @constructor

  constructor: (label = 'Button') ->
    super(template, {label: label}, {renderOnChange: false}, @_getButton)


  ##
  # Fills the button with the background color, essentially making it visible.
  #
  # @method _fill
  # @protected

  _fill: ->
    if @_getButton() then dom.addClass @_getButton(), 'sc-fill'


  ##
  # Shows the button by filling the background.
  #
  # @method show
  # @public

  show: @prototype._fill


  ##
  # Removes the fill from the button background, essentially hiding the button.
  #
  # @method _unfill
  # @protected

  _unfill: ->
    if @_getButton() then dom.removeClass @_getButton(), 'sc-fill'


  ##
  # Hides the button.
  #
  # @method hide
  # @public

  hide: @prototype._unfill


  ##
  # Enables the button.
  #
  # @method enable
  # @public

  enable: ->
    @enabled = true


  ##
  # Disables the button
  #
  # @method disable
  # @public

  disable: ->
    @disabled = true

  ##
  # Returns reference to the `button` DOM node.
  #
  # @method _getButton
  # @protected

  _getButton: ->
    @el.getElementsByTagName('button')[0]
