template   = require './template'
Button     = require './../button'


##
# Simple button component which
#
module.exports = class ProgressButton extends Button

  ##
  # The button progress, a floating point number between `0` and `1`.
  #
  # @property {number} progress
  # @public

  @property 'progress',
    set: (p) ->
      return p

  ##
  # ProgressButton constructor.
  #
  # @param {string} [label='Button'] - The initial button label.
  #
  # @constructor

  constructor: (label = 'Progress Button') ->
    super(label)
    @template = template
