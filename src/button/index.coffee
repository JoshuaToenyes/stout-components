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
      @disabled = !enabled
    get: ->
      !@disabled


  ##
  # Button constructor.
  #
  # @param {string} [label='Button'] - The initial button label.
  #
  # @constructor

  constructor: (label = 'Button') ->
    super(template, {label: label}, {renderOnChange: false}, @_getButton)


  ##
  # Returns reference to the button DOM node.
  #
  # @method _getButton
  # @protected

  _getButton: ->
    @el.getElementsByTagName('button')[0]
