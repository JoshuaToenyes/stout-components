_       = require 'lodash'
Model   = require '/Users/josh/work/stout/common/model/Model'
Console = require './index'

class TestModel extends Model
  @property 'output'

window.model = new TestModel output: ''

window.cons = new Console model, field: 'output'

setInterval ->
  model.output += _.now() + '\n'
, 100


document.getElementById('demo').appendChild cons.render()
