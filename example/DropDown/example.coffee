DropDown = require './../../DropDown'
demoEl = document.getElementById('demo')

m1 = new DropDown.MenuItem title: 'menu item #1'
m2 = new DropDown.MenuItem title: 'menu item #2'
se = new DropDown.Separator
m3 = new DropDown.MenuItem title: 'menu item #3'

window.dd = new DropDown
  parentEl: document.body
  attachedEl: demoEl
  menuItems: [m1, m2, se, m3]

dd.render()
m1.disable()
