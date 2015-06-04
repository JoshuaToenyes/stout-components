Model           = require '/Users/josh/work/stout/common/model/Model'
MaskedTextInput = require './../../MaskedTextInput'

class TestModel extends Model
  @property 'phone'
  @property 'dob'

window.model = new TestModel phone: '6197561954'

window.phone = new MaskedTextInput model,
  label: 'Phone Number'
  mask: '(888) 123-4566? \\x123'
  name: 'phone'
  placeholder: '(619) 555-1212'

window.dob = new MaskedTextInput model,
  label: 'Date of Birth'
  mask: '01/01/1985'
  name: 'dob'
  placeholder: '01/01/1985'
  bindRawValue: false

document.getElementById('demo').appendChild phone.render()
document.getElementById('demo').appendChild dob.render()
