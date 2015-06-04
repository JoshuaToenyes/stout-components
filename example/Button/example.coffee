Button = require './../../Button'

window.button = new Button label: 'Test Button'
button.el = document.getElementById('demo')

button.on 'click', (e) ->
  console.log 'clicked!'
  button.label = 'Clicked!'

button.on 'event', (e) ->
  console.log e.name

button.render()
