Input = require './index'

input = new Input label: 'Phone Number', mask: '(888) 123-4566 x8888888'
document.getElementById('demo').appendChild input.render()

for i in [0..4]
  input = new Input label: 'Label', placeholder: 'placeholder'
  document.getElementById('demo').appendChild input.render()
  window.input = input
