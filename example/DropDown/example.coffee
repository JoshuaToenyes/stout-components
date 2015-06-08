DropDown = require './../../DropDown'
demoEl = document.getElementById('demo')

window.dd = new DropDown
  parentEl: document.body
  attachedEl: demoEl
  menuItems: ['menu item 1', 'menu item 2', 'item #3']

dd.render()
