ProgressButton = require './../../ProgressButton'

window.button = new ProgressButton('Test Button')
button.el = document.getElementById('demo')

button.render()

document.querySelector('.spin').addEventListener 'click', ->
  button.spin()

document.querySelector('.stop').addEventListener 'click', ->
  button.stop()
