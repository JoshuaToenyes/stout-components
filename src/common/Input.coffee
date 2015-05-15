
Interactive = require './Interactive'


##
# Interactive component which can be enabled/disabled and triggers mouse events
# such as `hover`, `leave`, and events `active` and `focus`.
#
# @class Interactive

module.exports = class Input extends Interactive

  ##
  # The `id` attribute that should be applied to the input HTMLElement.
  #
  # @property id
  # @public

  @property 'id',
    default: ''


  ##
  # The `name` attribute that should be applied to the input HTMLElement.
  #
  # @property name
  # @public

  @property 'name',
    default: ''


  ##
  # The label for the input component.
  #
  # @property label
  # @public

  @property 'label',
    default: ''


  ##
  # Input class constructor.
  #
  # @constructor

  constructor: ->
    super arguments...

    @on 'change:id change:name change:label', =>
      if not @rendered then return
      @_getLabelTarget().nodeValue = @label
      @_getInputTarget().id = @id
      @_getInputTarget().name = @name

    if @name and @model and @model[@name]
      @model.stream @name, @_updateView


  ##
  # Returns the target primary input element of this component. In principle,
  # this is the HTMLElement that should have the `name` and `id` attributes
  # set. By default, this simply returns the first `input` element, but this
  # behavior may be overridden by extending classes.
  #
  # @method _getInputTarget
  # @protected

  _getInputTarget: ->
    @select 'input'


  ##
  # Returns the target primary input element of this component. In principle,
  # this is the HTMLElement that should have the `name` and `id` attributes
  # set. By default, this simply returns the first `input` element, but this
  # behavior may be overridden by extending classes.
  #
  # @method _getInputTarget
  # @protected

  _updateView: (v) =>
    @select('input').value = v


  ##
  # Returns the target label element of this component. This should return the
  # element which should have it's textual content changed if the `#label`
  # property changes. By default, this simply returns the first `label`
  # element, but this behavior may be overridden by extending classes.
  #
  # @method _getInputTarget
  # @protected

  _getLabelTarget: ->
    @select('label').childNodes[0]
