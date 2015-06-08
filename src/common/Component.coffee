$          = require '/Users/josh/work/stout/client/$'
dom        = require 'stout/common/utilities/dom'
ClientView = require '/Users/josh/work/stout/client/view/ClientView'


##
# Component class which represents a client-side component that exists in
# the users web browser.
#
# @class Component

module.exports = class Component extends ClientView

  ##
  # This property is `true` if this component is currently hidden.
  #
  # @property {boolean} hidden
  # @public

  @property 'hidden',
    serializable: false

    ##
    # Hides or shows the component based on the set boolean value.
    #
    # @setter

    set: (hidden) -> @visible = not hidden

    ##
    # Returns `true` if this component is currently hidden.
    #
    # @getter

    get: -> not @visible


  ##
  # This property is `true` if the button is currently visible, or filled.
  #
  # @property {boolean} visible
  # @public

  @property 'visible',
    serializable: false

    ##
    # Hides or shows the component based on the set boolean value.
    #
    # @setter

    set: (visible) -> if visible then @show() else @hide()

    ##
    # Returns `true` if this component is currently visible.
    #
    # @getter

    get: -> @isVisible()


  ##
  # Component constructor creates a new component instance and passes all
  # arguments to the parent ClientView class.
  #
  # @see stout/client/view/ClientView#constructor
  #
  # @constructor

  constructor: ->
    super arguments...

    # Hide and show callback timer.
    @_timer = null

    @classes.push 'sc-component'


  ##
  # Fades this component into view. By default, this method simply removes the
  # `sc-hidden` class from the element returned by `_getHideTarget()`. This
  # behavior may be overriden by extending classes for more complex
  # functionality. If the component is already visible or not rendered, calling
  # this method has no effect.
  #
  # @param {function} [cb] - Callback function executed when the component is
  # fully visible.
  #
  # @method show
  # @public

  show: (cb) =>
    if @rendered and @hidden
      $target = $ @_getHideTarget()
      $target.removeClass 'sc-hidden'
      if @_timer then clearTimeout @_timer
      @_timer = setTimeout (-> cb?.call @),
        $target.transitionDuration 'opacity'
    else
      cb?.call @
    @


  ##
  # Fades this component from view. By default, this method add the `sc-hidden`
  # class to the element returned by `_getHideTarget()`. This behavior may be
  # overriden by extending classes for more complex functionality. If the
  # component is already hidden or not rendered calling this method has no
  # effect.
  #
  # @param {function} [cb] - Callback function executed when the component is
  # hidden.
  #
  # @method hide
  # @public

  hide: (cb) =>
    if @rendered and @visible
      $target = $ @_getHideTarget()
      $target.addClass 'sc-hidden'
      if @_timer then clearTimeout @_timer
      @_timer = setTimeout (-> cb?.call @),
        $target.transitionDuration 'opacity'
    else
      cb?.call @
    @


  ##
  # Returns `true` or `false` indicating if this component is currently visible.
  # By default it just indicates if the element returned by `_getHideTarget()`
  # has the class `sc-hidden`. This behavior may be overriden by extending
  # classes for more complex functionality. This method will return `false` if
  # the component is not rendered.
  #
  # @method isVisible
  # @public

  isVisible: =>
    if @rendered
      not dom.hasClass @_getHideTarget(), 'sc-hidden'
    else
      false


  ##
  # Renders this component and adds the `sc-component` class to the root
  # element.
  #
  # @returns {HTMLElement} The root component element.
  #
  # @method render
  # @public
  render: ->
    super()
    #dom.addClass @el, 'sc-component'
    @el


  ##
  # Returns the target element that should be "hidden" if this component is
  # hidden from view. By default this method returns the root element (@el) of
  # the component, but this behavior may be overridden by extending classes
  # for more complex behavior.
  #
  # @method _getHideTarget
  # @protected

  _getHideTarget: -> @el
