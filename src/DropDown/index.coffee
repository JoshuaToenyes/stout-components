##
#

Foundation  = require 'stout/common/base/Foundation'
Interactive = require '../common/Interactive'
template    = require './template'
type        = require 'stout/common/utilities/type'



##
# The interval (in milliseconds) which the attached element's position is
# sampled and the drop-down is repositioned.
#
# @const POSITION_INTERVAL
# @private

POSITION_INTERVAL = 20



##
# Drop-down menu item class represents a single menu item. It is a standard
# `Interactive` which can be disabled and fire standard interaction events.
#
# @class MenuItem
# @public

class MenuItem extends Interactive

  @property 'title'

  constructor: (init) ->
    super (-> @title), null, {renderOnChange: false}, init
    @tagName = 'li'

  _getDisableTarget: -> @el



##
# Represents a separator line in a drop-down menu. It is not interactive and is
# simply a way for developers to easily add a separator to the menu.
#
# @class Separator
# @public

class Separator

  constructor: ->

  render: ->
    li = document.createElement 'li'
    li.className = 'sc-separator'
    li.appendChild document.createElement 'hr'
    li



##
# The DropDown class represents a generic drop-down menu which may appear
# and disappear using some external trigger. The drop-down may be closed in
# one of three ways:
#  - By clicking on a menu item.
#  - Clicking outside of the drop-down menu.
#  - If the cursor is outside the menu, wating `#hideTime` millseconds will
#    close the drop-down. (This timer is reset whenever the user hovers the
#    drop-down.)
#
# @class DropDown
# @public

module.exports = class DropDown extends Interactive

  ##
  # Static reference to the MenuItem class constructor.
  #
  # @member MenuItem
  # @public
  # @static

  @MenuItem: MenuItem


  ##
  # Static reference to the Separator class constructor.
  #
  # @member Separator
  # @public
  # @static

  @Separator: Separator


  ##
  # The members of the drop down menu.
  #
  # @property menuItems
  # @public

  @property 'menuItems',
    default: []


  ##
  # The element that the drop-down is attached to.
  #
  # @property attachedEl
  # @public

  @property 'attachedEl'

  ##
  # Amount of time to wait until the drop-down is closed automatically.
  #
  # @property hideTime
  # @public

  @property 'hideTime',
    default: 10000


  ##
  # Button constructor.
  #
  # @param {object} [init={}] - Initial property values.
  #
  # @constructor

  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init

    # Private interval which positions the drop-down menu by continuously
    # sampling the position of `@attachedEl` by running `@_positionEl`.
    @_int = null

    # Private timer used to automatically hide the drop-down after some time.
    @_hideTimer = null

    # Add the `sc-drop-down` class to the component container.
    @classes.push 'sc-drop-down'

    # Initially hide the drop-down menu.
    @classes.push 'sc-hidden'

    # Clear the hide-timer when the user hovers over the drop-down.
    @on 'hover', => clearTimeout @_hideTimer

    # Start the hide-timer when the user's mouse leaves the drop-down.
    @on 'leave', =>
      clearTimeout @_hideTimer
      @_hideTimer = setTimeout @close, @hideTime


  ##
  # Clears the positioning interval then calls super's `#destroy()` method.
  #
  # @see Component#destroy()
  #
  # @method destroy
  # @public

  destroy: ->
    if @_int then clearInterval @_int
    @_int = null
    super()


  ##
  # Renders the drop-down menu by iteratively rendering the menu items, then
  # then creating the interval which will keep the drop-down properly
  # positioned.
  #
  # @method render
  # @public

  render: ->
    super()

    # If there is already a positioning timer, clear it (there shouldn't be).
    if @_int then clearInterval @_int
    ul = @select 'ul'

    # Add event listeners to each menu item so we can close the drop-down when
    # any item is clicked.
    for li in @menuItems
      ul.appendChild li.render()
      li.on? 'click', @close

    # Create the interval to continuously position the drop-down element.
    @_int = setInterval @_positionEl, POSITION_INTERVAL

    # Stop clicks from propagating up to the body so we can detect clicks
    # anywhere outside the drop-down.
    @el.addEventListener 'click', (e) -> e.stopPropagation()

    # Return a reference to the root element.
    @el


  ##
  # Positions the drop-down menu below the element which it is attached to,
  # `attachedEl`. It also ensures that the drop-down does not appear off the
  # page, or partially off the page.
  #
  # @method _positionEl
  # @private

  _positionEl: =>
    pos = @attachedEl.getBoundingClientRect()
    epos = @el.getBoundingClientRect()
    left = Math.max(0, pos.left + 0.5 * pos.width - 0.5 * epos.width)
    left = Math.min(left, window.innerWidth - epos.width)
    top = Math.max(0, pos.top + pos.height)
    top = Math.min(top, window.innerHeight - epos.height)
    @el.style.left = left + 'px'
    @el.style.top = top + 'px'


  ##
  # Opens the drop-down menu by first rendering, then showing the component.
  #
  # @param {function} [cb] - Optional callback function executed when the drop
  # down is fully visible.
  #
  # @returns this
  #
  # @method open
  # @public

  open: (cb) ->
    @render()

    # Show on the next tick to trigger animation.
    setTimeout =>
      @show(cb)

      # Start the hide-timer when the drop-down is rendered.
      @_hideTimer = setTimeout @close, @hideTime

      # Listen for any click outside the drop-down (see our related
      # stopPropagation call in #render()) and close the drop-down.
      document.body.addEventListener 'click', @close
    , 0

    # Return a reference to `this`.
    @


  ##
  # Closes the drop-down menu by first hiding then unrendering the view.
  #
  # @param {function} [cb] - Optional callback function executed when the drop
  # down is fully hidden.
  #
  # @returns this
  #
  # @method close
  # @public

  close: (cb) =>

    # Clear a possibly pending hide-timer.
    clearTimeout @_hideTimer

    # Remove the listener for clicks outside the drop-down.
    document.body.removeEventListener 'click', @close

    # Remove close listeners on the menu items.
    for li in @menuItems
      li.off? 'click', @close

    # Fade-out the drop-down, then when it's not visible un render it.
    @hide =>
      @destroy()
      if type(cb).is('function') then cb.call @

    # Return a reference to `this`.
    @
