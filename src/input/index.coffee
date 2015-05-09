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

    @_mask = opts.mask

    @_lastKey = null

    # Bound model.
    @_model = null

    # Bound field of model.
    @_field = null

    # Update prevention flag, used when updating the model and a change on the
    # bound model should not trigger an update in the view.
    @_preventModelUpdate = false

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


  ##
  # Returns the label element associated with the input if there is one.
  #
  # @returns {HTMLElement} lable DOM node.
  #
  # @method _getLabel
  # @private

  _getLabel: ->
    @select('label')


  ##
  # Returns the outer HTMLElement object, label if there is one, or the input
  # element itself.
  #
  # @returns {HTMLElement} Outer label or input element.
  #
  # @method _getOuterElement
  # @private

  _getOuterElement: ->
    label = @select 'label'
    if label then label else @select 'input'


  ##
  # Renders the input and attaches event listeners to DOM elements.
  #
  # @returns {HTMLElement} Reference to container DOM element.
  #
  # @param render
  # @public

  render: ->
    super()

    @_getInput().addEventListener 'keydown', (e) =>
      @_lastKey = e.which || e.keyCode || e.charCode

    @_getInput().addEventListener 'input', (e) =>
      value = e.target.value
      if @_mask and @_lastKey isnt 8
        value = @_renderMask value
      @_preventModelUpdate = true
      @_updateView value
      @_updateModel value

    @el

  ##
  # Updates the value of the input in the view.
  #
  # @method _updateView
  # @protected

  _updateView: (value) ->
    @_getInput().value = value


  ##
  # Updates the value in the bound model.
  #
  # @method _updateModel
  # @protected

  _updateModel: (value) ->
    if @_model then @_model[@_field] = value


  ##
  # Binds this input to the passed model and field. When the model's field
  # changes the input will be updated to reflect the change.
  #
  # @param {Model} _model - The model to bind to.
  #
  # @param {string} _field - The field on the model to bind to.
  #
  # @method bind
  # @public

  bind: (@_model, @_field) ->
    @_model.on "change:#{@_field}", (e) =>
      if not @_preventModelUpdate
        value = e.data.value.toString()
        if @_mask then value = @_renderMask value
        @_updateView value.toString()
      @_preventModelUpdate = false


  _renderMask: (value) ->
    value = value.replace /[^\d]/g, ''
    maskedValue = ''
    i = j = 0

    # If the value is zero-length, then make the input blank.
    if value.length is 0 then return ''

    loop

      # If this character should be a value, place the value.
      if @_mask[i].match /\d/
        maskedValue += value[j]
        j++
        i++

      # Otherwise, place the masking character.
      else
        maskedValue += @_mask[i]
        i++

      # If we've reached the end of the mask, break.
      if i >= @_mask.length then break

      # If the next character should be user-supplied, and there are no more
      # user supplied characters, then break
      if @_mask[i].match(/\d/) and j >= value.length then break

    return maskedValue


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


  ##
  # Shows an input by fading it in.
  #
  # @method show
  # @public

  show: ->
    if @rendered then dom.removeClass @_getOuterElement(), 'sc-hidden'


  ##
  # Hides the input by fading it from view.
  #
  # @method hide
  # @public

  hide: ->
    if @rendered then dom.addClass @_getOuterElement(), 'sc-hidden'
