Button = require './../../Button'
ButtonGroup = require './../../ButtonGroup'
demoEl = document.getElementById('demo')

b1 = new Button
  label: 'No Icon Button'

b2 = new Button
  label: 'Button #2'

b3 = new Button
  label: 'Button #3'

b4 = new Button
  label: 'Far Right'

group = new ButtonGroup
  contents: [b1, b2, b3, b4],
  parentEl: demoEl

group.render()
