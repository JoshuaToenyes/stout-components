##
# Defines the Console component class, which is a simple console-like
# text-output component.

Container         = require './../common/Container'
FloatingContainer = require './../FloatingContainer'
template          = require './template'



##
# Modal window.
#
# @class Modal

module.exports = class Modal extends Container

  ##
  # Set to `true` if the close "x" should be shown on the modal.
  #
  # @property showClose
  # @type boolean
  # @default true
  # @public

  @property 'showClose',
    default: true


  ##
  # The modal header's title.
  #
  # @property title
  # @type string
  # @default null
  # @public

  @property 'title'


  ##
  # MaskedTextInput constructor.
  #
  # @constructor

  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init
    @_fc = new FloatingContainer
    @_fc.classes.push 'sc-modal'
    @classes.push 'sc-hidden'
    #@classes.push 'sc-modal'


  ##
  # Opens the modal window. Optionally, a title and modal contents may be
  # passed to this method which will override the existing title and modal.
  # This method is essentially equivalent to calling `#render()` followed by
  # `#show()`.
  #
  # @param {string} [title] - The modal title.
  #
  # @param {string|HTMLElement|ClientView} [contents] - The modal contents.
  #
  # @todo This should return a composed promise.
  #
  # @method open
  # @public

  open: (title, contents) ->
    if @visible then return
    if title then @title = title
    if contents then @contents = contents
    @render()
    setTimeout @show, 0


  render: ->
    @_fc.render(super())
