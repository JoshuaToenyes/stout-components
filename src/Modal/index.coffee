##
# Defines the Console component class, which is a simple console-like
# text-output component.

template    = require './template'
Floating    = require './../common/Floating'



##
# Modal window.
#
# @class Modal

module.exports = class Modal extends Floating

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
  # MaskedTextInput constructor.
  #
  # @constructor

  constructor: (model, init = {}) ->
    super template, model, {renderOnChange: false}, init

    model.on "change:#{@field}", @_updateView
