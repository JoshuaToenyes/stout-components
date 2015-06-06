Button = require './../../Button'
atomIcon = require './atom-icon.svg'
demoEl = document.getElementById('demo')


button = new Button
  label: 'No Icon Button'
  parentEl: demoEl

btop = new Button
  label: 'Top Label'
  parentEl: demoEl
  svgIcon: atomIcon
  iconPosition: 'top'

bbottom = new Button
  label: 'Bottom Label'
  parentEl: demoEl
  svgIcon: atomIcon
  iconPosition: 'bottom'

bleft   = new Button
  label: 'Left Label'
  parentEl: demoEl
  svgIcon: atomIcon
  iconPosition: 'left'

bright  = new Button
  label: 'Right Label'
  parentEl: demoEl
  svgIcon: atomIcon
  iconPosition: 'right'

bnolabel  = new Button
  parentEl: demoEl
  svgIcon: atomIcon

button.render()
btop.render()
bbottom.render()
bleft.render()
bright.render()
bnolabel.render()
