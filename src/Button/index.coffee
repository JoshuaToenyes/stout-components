dom         = require 'stout/common/utilities/dom'
template    = require './template'
Interactive = require '../common/Interactive'


##
# Simple button component which
#
module.exports = class Button extends Interactive

  ##
  # The button label.
  #
  # @property label
  # @public

  @property 'label',
    default: ''


  ##
  # Button constructor.
  #
  # @param {string} [label='Button'] - The initial button label.
  #
  # @constructor

  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init


  ##
  # Fills the button with the background color, making it visible.
  #
  # @method show
  # @protected

  show: ->
    if @rendered then dom.addClass @_getButton(), 'sc-fill'


  ##
  # Removes the fill from the button background, hiding the button.
  #
  # @method hide
  # @protected

  hide: ->
    if @rendered then dom.removeClass @_getButton(), 'sc-fill'


  ##
  # Returns the button element.
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getButton
  # @protected

  _getButton: -> @select 'button'


  ##
  # Returns the element that should be disabled (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getDisableTarget
  # @protected

  _getDisableTarget: @.prototype._getButton


  ##
  # Returns the element that should trigger a hover event (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getHoverTarget
  # @protected

  _getHoverTarget: @.prototype._getButton
