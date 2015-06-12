dom        = require 'stout/common/utilities/dom'
Component  = require './Component'

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
    serializable: false

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
    serializable: false

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
    b = @_getHoverTarget()
    b.addEventListener 'click', @_onClick
    b.addEventListener 'mousedown', @_onMouseDown
    b.addEventListener 'focus', @_onFocus
    b.addEventListener 'mouseenter', @_onMouseEnter
    b.addEventListener 'mouseleave', @_onMouseLeave
    @el


  destroy: ->
    b = @_getHoverTarget()
    b.removeEventListener 'click', @_onClick
    b.removeEventListener 'mousedown', @_onMouseDown
    b.removeEventListener 'focus', @_onFocus
    b.removeEventListener 'mouseenter', @_onMouseEnter
    b.removeEventListener 'mouseleave', @_onMouseLeave
    super()


  _onClick: (e) =>
    @fire 'click', e


  _onMouseDown: (e) =>
    @fire 'active', e


  _onFocus: (e) =>
    @fire 'focus', e


  _onMouseEnter: (e) =>
    clearTimeout @_hoverTimer
    if @_state is STATE.HOVER then return
    @_state = STATE.HOVER
    @fire 'hover', e


  _onMouseLeave: (e) =>
    self = @
    @_hoverTimer = setTimeout ->
      self._state = STATE.DEFAULT
      self.fire 'leave', e
    , 10


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
