Component  = require './Component'


##
# Interactive component which can be enabled/disabled and triggers mouse events
# such as `hover`, `leave`, and events `active` and `focus`.
#
# @class Interactive

module.exports = class Output extends Component

  ##
  # Output component constructor.
  #
  # @see Component#constructor
  #
  # @constructor

  constructor: ->
    super arguments...
