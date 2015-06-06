##
# Defines the GroupContainer class, a generic container which may contain
# multiple internal elements, strings, or views to be rendered.
#
# @fileoverview

ClientView = require '/Users/josh/work/stout/client/view/ClientView'
Component  = require './../common/Component'
type       = require '/Users/josh/work/stout/common/utilities/type'
template   = require './template'


##
# The GroupContainer class is a generic container which may contain multiple
# element, views, or strings which are rendered in-order when the
# GroupContainer is rendered.
#
# @class GroupContainer
# @public

module.exports = class GroupContainer extends Component

  ##
  # The array of contents to be rendered within the container.
  #
  # @property contents
  # @type Array<string|HTMLElement|ClientView>
  # @public

  @property 'contents',
    default: []


  ##
  # GroupContainer component constructor.
  #
  # @see Component#constructor
  #
  # @constructor

  constructor: (init) ->
    super template, null, {renderOnChange: false}, init

    # Add the `sc-group-container` class to the container's class list.
    @classes.push 'sc-group-container'


  ##
  # Renders each of the contained content items in-order and appends them
  # to the group container.
  #
  # @returns {HTMLElement} The group's root HTMLElement.
  #
  # @method render
  # @public

  render: (contents) ->
    super()
    if contents then @contents = contents
    cc = @select('.sc-container-contents')
    for item in @contents
      if type(item).isHTMLElement()
        cc.appendChild @contents
      else if type(item).is 'string'
        cc.innerHTML += @contents
      else if type(item).is(ClientView)
        cc.appendChild item.render()
    @el
