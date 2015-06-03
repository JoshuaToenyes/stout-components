ProgressBar = require './index'
Model       = require 'stout/common/model/Model'

class SampleModel extends Model
  @property 'progress',
    default: 0
  constructor: -> super arguments...

window.model = new SampleModel {progress: Math.random()}

window.bar = new ProgressBar model
bar.el = document.getElementById('demo')

document.querySelector('input[type="range"]').oninput = (e) ->
  model.progress = +e.target.value / 100

bar.render()
