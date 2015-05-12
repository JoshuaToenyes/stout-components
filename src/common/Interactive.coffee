dom        = require 'stout/common/utilities/dom'
template   = require './template'
Hoverable  = require '../common/Hoverable'
Model      = require 'stout/common/model/Model'

STATE =
  DEFAULT: 1  # Normal static state.
  HOVER:   2  # Mouse is over the button.
  ACTIVE:  3  # Mouse is down over button.
  FOCUS:   4  # Button is focused.


##
# Interactive component which can be enabled/disabled and triggers mouse events
# such as `hover`, `leave`, and events `active` and `focus`.
#
# @class Interactive

module.exports = class Interactive extends Component

  ##
  # If the button is currently disabled.
  #
  # @property {boolean} disabled
  # @public

  @property 'disabled',

    ##
    # Disables or enables the component based on the set boolean value.
    #
    # @setter

    set: (disabled) -> @enabled = not disabled

    ##
    # Returns `true` if this component is currently disabled.
    #
    # @getter

    get: -> not @enabled


  ##
  # If the button is currently disabled (the inverse of disabled).
  #
  # @property {boolean} enabled
  # @public

  @property 'enabled',

    ##
    # Enables or disables the component based on the set boolean value.
    #
    # @setter

    set: (enabled) -> if enabled then @enable() else @disable()

    ##
    # Returns `true` if this component is currently enabled.
    #
    # @getter

    get: -> @isEnabled()


  ##
  # Interactive constructor creates a new Interactive component instance and
  # passes all arguments to the parent class.
  #
  # @see Component#constructor
  #
  # @constructor

  constructor: ->
    super arguments...

    @registerEvents 'hover leave active focus'
    @_hoverTimer = null
    @_state = STATE.DEFAULT


  ##
  # Enables this interactive component. By default it removes the `disabled`
  # attribute from the element returned by `_getDisableTarget()`. This behavior
  # may be overriden by extending classes for more complex behavior. If this
  # component is not yet rendered, or is not disabled calling this method has
  # no effect.
  #
  # @method enable
  # @public

  enable: -> if @rendered then @_getDisableTarget().removeAttribute 'disabled'


  ##
  # Disabled this interactive component. By default it add the `disabled`
  # attribute to the element returned by `_getDisableTarget()`. This behavior
  # may be overriden by extending classes for more complex behavior. If this
  # component is not yet rendered, or is already disabled calling this method
  # has no effect.
  #
  # @method disable
  # @public

  disable: -> if @rendered then @_getDisableTarget().setAttribute 'disabled', ''


  ##
  # Returns `true` or `false` indicating if this component is currently
  # disabled. By default it just indicates if the element returned by
  # `_getDisableTarget()` has the attribute `disabled`. This behavior may be
  # overriden by extending classes for more complex functionality. This method
  # will return `false` if the component is not rendered.
  #
  # @method isVisible
  # @public

  isEnabled: ->
    if @rendered
      @_getDisableTarget().hasAttribute 'disabled'
    else
      false


  ##
  # Renders this component and adds approriate event listeners for hover events.
  #
  # @returns {HTMLElement} The rendered root HTML DOM node.
  #
  # @method render
  # @public

  render: ->
    super()

    self = @

    b = @_getHoverTarget()

    b.addEventListener 'click', (e) ->
      self.fire 'click', e

    b.addEventListener 'mousedown', (e) ->
      self.fire 'active', e

    b.addEventListener 'focus', (e) ->
      self.fire 'focus', e

    b.addEventListener 'mouseenter', (e) ->
      clearTimeout self._hoverTimer
      if self._state is STATE.HOVER then return
      self._state = STATE.HOVER
      self.fire 'hover', e

    b.addEventListener 'mouseleave', (e) ->
      self._hoverTimer = setTimeout ->
        self._state = STATE.DEFAULT
        self.fire 'leave', e
      , 10

    @el


  ##
  # Returns the target element that should be "disabled". By default this
  # method returns the first `input` element of the component but this behavior
  # may be overridden by extending classes for more complex behavior.
  #
  # @method _getDisableTarget
  # @protected

  _getDisableTarget: -> @select 'input'


  ##
  # Returns the target element that should trigger hover and mouse events. By
  # default it returns the component's root element.
  #
  # @method _getHoverTarget
  # @protected

  _getHoverTarget: -> @el
