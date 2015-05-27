##
# Defines the Floating container class.
#
# @fileoverview

Container = require './../common/Container'
template  = require './template'


##
# Generic floating container component. It defines a container which may be
# positioned horizontally left, center or right, and vertically top, middle, or
# bottom.
#
# @class Floating

module.exports = class Floating extends Container

  ##
  # The horizontal alignment of this floating container. Changing this property
  # will trigger a re-render of the entire container.
  #
  # @property horizontalAlign
  # @default 'center'
  # @type string
  # @values 'left', 'center', 'right'
  # @public

  @property 'horizontalAlign',
    default: 'center'
    values: ['left', 'center', 'right']


  ##
  # The vertical alignment of this floating container. Changing this property
  # will trigger a re-render of the entire container.
  #
  # @property verticalAlign
  # @default 'middle'
  # @type string
  # @values 'top', 'middle', 'bottom'
  # @public

  @property 'verticalAlign',
    default: 'middle'
    values: ['top', 'bottom', 'middle']


  ##
  # Floating container component constructor.
  #
  # @param {object} init - Object initialization.
  #
  # @constructor

  constructor: (init) ->
    super template, null, {renderOnChange: false}, init

    @on 'change:horizontalAlign change:verticalAlign', ->
      if @rendered then @render()
