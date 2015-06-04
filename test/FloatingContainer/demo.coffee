_        = require 'lodash'
FloatingContainer = require './../../FloatingContainer'

e = document.createElement 'h2'
e.textContent = 'Floating Content'

window.floater = new FloatingContainer contents: e

document.getElementById('demo').appendChild floater.render()
