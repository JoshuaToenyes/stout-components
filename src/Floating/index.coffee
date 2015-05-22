Output   = require './../common/Output'
template = require './template'


##
# Generic floating component.
#
# @class Floating

module.exports = class Floating extends Output

  @property 'content'

  @property 'horizontalAlign',
    default: 'center'
    values: ['left', 'center', 'right']

  @property 'verticalAlign',
    default: 'middle'
    values: ['top', 'bottom', 'middle']

  ##
  # Floating component constructor.
  #
  # @see Output#constructor
  #
  # @constructor

  constructor: (init) ->
    super template, null, {renderOnChange: false}, init

    @on 'change:content change:horizontalAlign change:verticalAlign', @render


  ##
  #
  # @param {string} contents - The HTML contents of the floating container.
  #
  # @method render
  # @public
  render: (contents) ->
    super()
