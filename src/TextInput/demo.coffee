Model = require '/Users/josh/work/stout/common/model/Model'
TextInput = require './index'

class TestModel extends Model
  @property 'first'
  @property 'last'

window.model = new TestModel first: 'John', last: 'Smith'

f = new TextInput model, label: 'First Name', name: 'first'
l = new TextInput model, label: 'Last Name', name: 'last'

document.getElementById('demo').appendChild f.render()
document.getElementById('demo').appendChild l.render()
