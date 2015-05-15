_           = require 'lodash'
dom         = require 'stout/common/utilities/dom'
Input       = require '../common/Input'
template    = require './template'


##
# Simple text input.
#
module.exports = class TextInput extends Input

  @property 'placeholder',
    default: ''


  constructor: (model, init = {}) ->
    super template, model, {renderOnChange: false}, init

    @on 'change:placeholder', =>
      if @rendered then @_getInputTarget().placeholder = @placeholder


  ##
  # Renders the input and attaches event listeners to DOM elements.
  #
  # @returns {HTMLElement} Reference to container DOM element.
  #
  # @param render
  # @public

  render: ->
    super()

    @_getInputTarget().addEventListener 'input', (e) =>
      @model[@name] = e.target.value

    @el
