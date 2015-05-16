$           = require '/Users/josh/work/stout/client/$'
keys        = require '/Users/josh/work/stout/client/keys'
TextInput   = require './../TextInput'


##
# Masked text input.
#
# @class MaskedTextInput

module.exports = class MaskedTextInput extends TextInput

  ##
  # The mask definition. If no mask is set, the input essentially degrades to
  # a basic TextInput.
  #
  # [0-9]     Indicates a numeric character
  #
  # [a-zA-Z]  Indicates a letter character.
  #
  # *         Indicates a numeric or letter character.
  #
  # @property mask
  # @type string
  # @public

  @property 'mask'


  ##
  # Option to bind the raw or masked value to the model. If this flag is
  # `true` (the default) then the raw (unmasked) value with be bound to the
  # model, otherwise the masked value will be bound.
  #
  # @property bindRawValue
  # @type boolean
  # @public

  @property 'bindRawValue',
    serializable: false
    default: true


  ##
  # MaskedTextInput constructor.
  #
  # @constructor

  constructor: ->
    super arguments...

    ##
    # The last key pressed by the user within this masked input.
    #
    # @member _lastKey
    # @private
    @_lastKey = null


  ##
  # Takes-in a passed value, applies the mask, and returns the masked and
  # raw values of the input.
  #
  # @param {string} value - The value to mask.
  #
  # @returns {Array<string>} - A two-member array consisting of
  # [maskedValue, rawValue].
  #
  # @method _renderMask
  # @private

  _renderMask: (value) ->

    # If passed nothing, just return empty strings.
    if not value then return ['', '']

    # If there is no mask set, just return the passed value.
    if not @mask then return [value, value]

    # Make sure we're working with a string value.
    value = value.toString()

    # Throw away everything that is not a digit or a character.
    value = value.replace /[^\d\w]/g, ''

    # If the value is zero-length, then make the input blank.
    if value.length is 0 then return ''

    # Create an accumulator for our masked value.
    maskedValue = ''

    # i tracks where we are in the mask.
    i = 0

    # j tracks where we are in the input value.
    j = 0

    # Loop through each character in the mask.
    loop

      # If the mask indicates that an input character should be placed
      # at this position, and the input character matches the type indicated
      # by the mask, then place the input character in this position.
      if (@mask[i].match(/[\d]/) and value[j].match(/[\d]/)) or
         (@mask[i].match(/[a-zA-Z]/) and value[j].match(/[a-zA-Z]/)) or
         (@mask[i].match(/\*/) and value[j].match(/[\w\d]/))

        maskedValue += value[j]
        j++
        i++

      # If this character is a mask-literal, then add it to the output.
      else if @mask[i].match(/[^\w*]/)
        maskedValue += @mask[i]
        i++

      # If this character should be user-input, but does not match what the
      # mask indicates it should be, the break out of the loop because the
      # character at this location is not valid and should not be included.
      else
        break

      # If we've reached the end of the mask, break.
      if i >= @mask.length then break

      # If the next character should be user-supplied, and there are no more
      # user supplied characters, then break
      if @mask[i].match(/[\w*]/) and j >= value.length then break

    rawValue = value.substring 0, j

    # Return both the masked value and the raw, non-formatted value.
    [maskedValue, rawValue]


  ##
  # Attaches relevant listeners and renders the component.
  #
  # @method render
  # @override
  # @public

  render: ->
    super()
    $(@_getInputTarget()).keydown (e) => @_lastKey = e.code
    @el


  ##
  # Called whenever the model value changes. When this occurs, if there is a
  # mask, calculate the raw and masked value of the model value. Update the view
  # to the masked value. If there is no mask set, simply set the view to the
  # raw value in the model.
  #
  # @method _updateView
  # @override
  # @protected

  _updateView: (v) =>
    [masked, raw] = @_renderMask v
    @select('input').value = masked


  ##
  # Called whenever the input value changes. When this occurs, if there is a
  # mask, calculate the raw and masked value of the input. Update the view
  # to the masked value (stripping any invalid characters) and update the model
  # to the raw value. If there is no mask set, simply set the model to the
  # raw input value.
  #
  # @method _updateModel
  # @override
  # @protected

  _updateModel: (v) =>
    [masked, raw] = @_renderMask v
    if @_lastKey isnt keys.BACKSPACE
      @select('input').value = masked
    if @bindRawValue
      @model[@name] = raw
    else
      @model[@name] = masked


  ##
  # Masks the model's value prior to rendering.
  #
  # @method _preRender
  # @override
  # @protected

  _preRender: (obj) ->
    [masked, raw] = @_renderMask obj.model[@name]
    obj.model[@name] = masked
    super(obj)
