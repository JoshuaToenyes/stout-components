##
# Defines the Button component class.
#
# @author Joshua Toenyes <josh@goatriot.com>

dom         = require 'stout/common/utilities/dom'
template    = require './template'
Interactive = require '../common/Interactive'


##
# Simple Button component class.
#
# @class Button
# @public

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
  # @param {object} [init={}] - Initial property values.
  #
  # @param {string} [init.label=''] - Button label.
  #
  # @constructor

  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init


  ##
  # Fills the button with the background color, making it visible.
  #
  # @method show
  # @override
  # @protected

  show: ->
    if @rendered then dom.addClass @_getButton(), 'sc-fill'


  ##
  # Removes the fill from the button background, hiding the button.
  #
  # @method hide
  # @override
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
  # @override
  # @protected

  _getDisableTarget: @.prototype._getButton


  ##
  # Returns the element that should trigger a hover event (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getHoverTarget
  # @override
  # @protected

  _getHoverTarget: @.prototype._getButton
