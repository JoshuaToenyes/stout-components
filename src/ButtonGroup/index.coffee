##
# Defines the ButtonGroup component class.
#
# @author Joshua Toenyes <josh@goatriot.com>

GroupContainer = require './../GroupContainer'
template = require './template'


##
#
#
# @class ButtonGroup
# @public

module.exports = class ButtonGroup extends GroupContainer

  constructor: ->
    super arguments...

    @classes.push 'sc-button-group'
