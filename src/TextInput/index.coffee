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
