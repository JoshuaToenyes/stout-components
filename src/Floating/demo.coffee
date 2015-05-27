_        = require 'lodash'
Floating = require './index'

e = document.createElement 'h2'
e.textContent = 'Floating Content'

window.floater = new Floating contents: e

document.getElementById('demo').appendChild floater.render()
