$           = require '/Users/josh/work/stout/client/$'
type        = require '/Users/josh/work/stout/common/utilities/type'
err         = require '/Users/josh/work/stout/common/err'
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
  # Creates a two-way data binding to the passed model if set to `true`.
  #
  # @property bind
  # @public

  @property 'bind',
    default: true


  ##
  # Input class constructor.
  #
  # @constructor

  constructor: ->
    super arguments...

    if @bind and @name and type(@model[@name]).is 'undefined'
      throw new err.PropertyErr "Model does not have property with name
      `#{@name}`. To bind to the passed model it must contain a property
      which matches the Input class's `name` property, or the `bind`
      property of the Input instance should be set to `false`."

    # If the label property is changed, update the view.
    @on 'change:label', =>
      if not @rendered then return
      @_getLabelTarget().nodeValue = @label

    # If data binding is enabled, and this Input has a `name` set, and there
    # is a passed model, create the "model --> view" binding. This binding
    # will update the view whenever the corresponding property of the model
    # changes.
    if @bind and @name and @model
      @model.stream @name, @_updateView


  ##
  # Renders the input and attaches event listeners to DOM elements.
  #
  # @returns {HTMLElement} Reference to container DOM element.
  #
  # @param render
  # @public

  render: ->
    super()

    $(@_getInputTarget()).input (e) =>
      @_updateModel e.target.value

    @el


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
  # This essentially creates the "model --> view" binding.
  #
  # @method _updateView
  # @protected

  _updateView: (v) =>
    @select('input').value = v


  ##
  # Updates the corresponding property on the model to the passed value. This
  # function should be called whenever something in the view changes that
  # should be reflected in the model, i.e. the user updates an input field
  # which should update the model. By default, this function is a simple
  # direct update. It may may be overridden by extending classes for more
  # advanced functionality.
  #
  # This essentially creates the "view --> model" binding.
  #
  # @method _updateModel
  # @protected

  _updateModel: (v) =>
    @model[@name] = v


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
