_        = require 'lodash'
Floating = require './index'

e = document.createElement 'h2'
e.textContent = 'Floating Content'

window.floater = new Floating content: e 

document.getElementById('demo').appendChild floater.render()
