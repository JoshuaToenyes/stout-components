##
#

Foundation  = require 'stout/common/base/Foundation'
Component   = require '../common/Component'
Interactive = require '../common/Interactive'
template    = require './template'



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
#
# @class DropDown
# @public

module.exports = class DropDown extends Component

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

    # Add the `sc-button` class to the component container.
    @classes.push 'sc-drop-down'


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
    if @_int then clearInterval @_int
    ul = @select 'ul'
    for li in @menuItems
      ul.appendChild li.render()
    @_int = setInterval @_positionEl, POSITION_INTERVAL
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
