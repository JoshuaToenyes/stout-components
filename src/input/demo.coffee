Model = require 'stout/common/model/Model'
Input = require './index'

class TestModel extends Model
  @property 'phone'

window.model = new TestModel

window.input = input = new Input label: 'Phone Number', mask: '(888) 123-4566'
document.getElementById('demo').appendChild input.render()

input.bind model, 'phone'

for i in [0..4]
  input = new Input label: 'Label', placeholder: 'placeholder'
  document.getElementById('demo').appendChild input.render()
