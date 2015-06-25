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
    @_disabled = false
    @_state = STATE.DEFAULT


  ##
  # Enables this interactive component. By default it removes the `disabled`
  # attribute from the element returned by `_getDisableTarget()`. This behavior
  # may be overriden by extending classes for more complex behavior. If this
  # component is not yet rendered, or is not disabled calling this method has
  # no effect.
  #
  # @returns @
  #
  # @method enable
  # @public

  enable: ->
    @_disabled = false
    if @rendered then @_getDisableTarget().removeAttribute 'disabled'
    @


  ##
  # Disabled this interactive component. By default it add the `disabled`
  # attribute to the element returned by `_getDisableTarget()`. This behavior
  # may be overriden by extending classes for more complex behavior. If this
  # component is not yet rendered, or is already disabled calling this method
  # has no effect.
  #
  # @returns @
  #
  # @method disable
  # @public

  disable: ->
    @_disabled = true
    if @rendered then @_getDisableTarget().setAttribute 'disabled', ''
    @


  ##
  # Returns `true` or `false` indicating if this component is currently
  # disabled. By default it just indicates if the element returned by
  # `_getDisableTarget()` has the attribute `disabled`. This behavior may be
  # overriden by extending classes for more complex functionality. This method
  # will return `false` if the component is not rendered.
  #
  # @returns {boolean} `true` if enabled, otherwise false.
  #
  # @method isEnabled
  # @public

  isEnabled: -> not @_disabled


  ##
  # Returns the inverse of `isEnabled()`.
  #
  # @see #isEnabled()
  #
  # @returns {boolean} `true` if disabled, otherwise false.
  #
  # @method isDisabled
  # @public

  isDisabled: -> not @isEnabled()


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
    if @_disabled
      @_getDisableTarget()?.setAttribute 'disabled', ''
    else
      @_getDisableTarget()?.removeAttribute 'disabled'
    @el


  ##
  # Removes all attached DOM event listeners and calls the parent `destroy()`
  # method.
  #
  # @method destroy
  # @public
  
  destroy: ->
    b = @_getHoverTarget()
    b.removeEventListener 'click', @_onClick
    b.removeEventListener 'mousedown', @_onMouseDown
    b.removeEventListener 'focus', @_onFocus
    b.removeEventListener 'mouseenter', @_onMouseEnter
    b.removeEventListener 'mouseleave', @_onMouseLeave
    super()


  ##
  # Called when a native click event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `click` event is fired.
  #
  # @method _onClick
  # @private

  _onClick: (e) =>
    if @enabled then @fire 'click', e


  ##
  # Called when a native mouse down event is detected on the hover target
  # element. If this Interactive is enabled, a corresponding `active` event
  # is fired.
  #
  # @method _onMouseDown
  # @private

  _onMouseDown: (e) =>
    if @enabled then @fire 'active', e


  ##
  # Called when a native focus event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `focus` event is fired.
  #
  # @method _onFocus
  # @private

  _onFocus: (e) =>
    if @enabled then @fire 'focus', e


  ##
  # Private method called when a native mouse enter event is detected. This
  # enter event is used to trigger a corresponding `hover` event.
  #
  # @method _onMouseEnter
  # @private

  _onMouseEnter: (e) =>
    clearTimeout @_hoverTimer
    if @_state is STATE.HOVER then return
    @_state = STATE.HOVER
    @fire 'hover', e


  ##
  # Private method called when a native mouse leave event is detected. This
  # enter event is used to trigger a corresponding `leave` event, signalling
  # the end of a hover.
  #
  # @method _onMouseLeave
  # @private

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
