_          = require 'lodash'
dom        = require 'stout/common/utilities/dom'
Hoverable  = require '../common/Hoverable'

# Input templates.
templates =
  'with-label':     require './with-label'
  'without-label':  require './without-label'

##
# Simple text input.
#
module.exports = class Input extends Hoverable

  ##
  # Input disabled property. When disabled, the user cannot enter text into the
  # input element.
  #
  # @property {boolean} disabled
  # @public

  @property 'disabled',

    ##
    # If true, disables the input.
    #
    # @setter

    set: (disable) ->
      if disable
        @_getInput()?.setAttribute 'disabled', 'true'
      else
        @_getInput()?.removeAttribute 'disabled'

    ##
    # Returns `true` if the input is currently disabled.
    #
    # @getter

    get: ->
      return @_getInput()?.hasAttribute 'disabled'


  ##
  # If the input is currently enabled (the inverse of disabled).
  #
  # @property {boolean} enabled
  # @public

  @property 'enabled',

    ##
    # If true, enables the input.
    #
    # @setter

    set: (enabled) ->
      @disabled = not enabled

    ##
    # Returns `true` if the input is currently enabled.
    #
    # @getter

    get: ->
      not @disabled


  ##
  # This property is `true` if the input is currently hidden, or unfilled.
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
      not dom.hasClass @_getOuterElement(), 'sc-hidden'





  constructor: (opts = {}) ->
    opts.label       or= ''
    opts.placeholder or= ''
    opts.template    or= 'with-label'
    opts.name        or= ''
    opts.id          or= ''

    model =
      placeholder:  opts.placeholder
      label:        opts.label
      name:         opts.name
      id:           opts.id

    super templates[opts.template],
      model
      {renderOnChange: false},
      @_getInput


  ##
  # Returns the input HTMLElement DOM node.
  #
  # @returns {HTMLElement} input DOM node.
  #
  # @method _getInput
  # @private

  _getInput: ->
    @select('input')


  _getLabel: ->
    @select('label')


  _getOuterElement: ->
    label = @select 'label'
    if label then label else @select 'input'



  ##
  # Enables the input.
  #
  # @method enable
  # @public

  enable: ->
    @enabled = true


  ##
  # Disables the input.
  #
  # @method disable
  # @public

  disable: ->
    @disabled = true


  show: ->
    if @rendered
      dom.removeClass @_getOuterElement(), 'sc-hidden'

  hide: ->
    if @rendered
      dom.addClass @_getOuterElement(), 'sc-hidden'
