Input = require './index'

for i in [0..4]
  input = new Input label: 'Label', placeholder: 'placeholder'
  document.getElementById('demo').appendChild input.render()
  window.input = input
