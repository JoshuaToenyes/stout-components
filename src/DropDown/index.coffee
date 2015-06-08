##
#

Component = require '../common/Component'
template  = require './template'


##
#
# @class DropDown
# @public

module.exports = class DropDown extends Component

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

    @timer = null

    # Add the `sc-button` class to the component container.
    @classes.push 'sc-drop-down'


  destroy: ->
    if @timer then clearInterval @timer
    super()


  empty: ->
    if @timer then clearInterval @timer
    super()


  render: ->
    super()
    @timer = setInterval @_positionEl, 20
    @el


  _positionEl: =>
    pos = @attachedEl.getBoundingClientRect()
    epos = @el.getBoundingClientRect()
    left = Math.max(0, pos.left + 0.5 * pos.width - 0.5 * epos.width)
    left = Math.min(left, window.innerWidth - epos.width)
    top = Math.max(0, pos.top + pos.height)
    top = Math.min(top, window.innerHeight - epos.height)
    @el.style.left = left + 'px'
    @el.style.top = top + 'px'
