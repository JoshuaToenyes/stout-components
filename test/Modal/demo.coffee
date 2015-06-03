_       = require 'lodash'
Modal = require './index'

window.modal = new Modal
  contents: 'Select the timezone where this thing you are talking about should occur.',
  title: 'Set Expiration Date for Thing'
  showClose: true

document.getElementById('demo').appendChild modal.render()
