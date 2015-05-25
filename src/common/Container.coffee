Component  = require './Component'


##
#
# @class Container

module.exports = class Container extends Component

  @property 'contents'

  ##
  # Output component constructor.
  #
  # @see Component#constructor
  #
  # @constructor

  constructor: ->
    super arguments...
