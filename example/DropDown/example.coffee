DropDown = require './../../DropDown'
Button = require './../../Button'
demoEl = document.getElementById('demo')

button = new Button
  label: 'Drop Down Menu'
  parentEl: demoEl

window.m1 = new DropDown.MenuItem title: 'menu item #1'
m2 = new DropDown.MenuItem title: 'menu item #2'
se = new DropDown.Separator
m3 = new DropDown.MenuItem title: 'menu item #3'

button.render()

window.dd = new DropDown
  parentEl: document.body
  attachedEl: button.select('button')
  menuItems: [m1, m2, se, m3]

m1.disable()

button.on 'click', ->
  if dd.isVisible()
    dd.close()
  else
    dd.open()
