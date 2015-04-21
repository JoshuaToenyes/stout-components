Button = require './index'

window.button = new Button('Test Button')
button.el = document.getElementById('demo')

button.on 'click', (e) ->
  console.log 'clicked!'
  button.label = 'Clicked!'

# button.on 'hover', (e) ->
#   console.log 'hover!'
#   button.label = 'Hover'

# button.on 'leave', (e) ->
#   console.log 'leave!'
#   button.label = 'Test Button'
#
# button.on 'active', (e) ->
#   console.log 'active!'
#
# button.on 'focus', (e) ->
#   console.log 'focus!'
#   button.label = 'Focused...'


button.render()
