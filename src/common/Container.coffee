##
# Defines the Container class, a generic container.
#
# @fileoverview

ClientView = require 'stout/client/view/ClientView'
Component  = require './Component'
type       = require '/Users/josh/work/stout/common/utilities/type'


##
# A generic container view which may contain an inner-view (or subview) which
# may be another ClientView, an HTMLElement, or a string (HTML or text).
#
# @class Container
# @public

module.exports = class Container extends Component

  ##
  # The contents to be rendered within the container.
  #
  # @property contents
  # @type string|HTMLElement|ClientView
  # @public

  @property 'contents',
    get: (c) ->
      if c instanceof ClientView
        c.render()
      else
        c


  ##
  # Container component constructor.
  #
  # @see Component#constructor
  #
  # @constructor

  constructor: ->
    super arguments...


  ##
  # Renders the container.
  #
  # @param {string|HTMLElement|ClientView} [contents] - Optional passed content.
  # If defined, then the `#content` property is set to the passed value before
  # the view is rendered.
  #
  # @method render
  # @public

  render: (contents) ->
    super()
    if contents then @contents = contents
    if type(@contents).isHTMLElement()
      @select('.sc-container-contents').innerHTML = ''
      @select('.sc-container-contents').appendChild @contents
    else
      @select('.sc-container-contents').innerHTML = @contents
    @el
