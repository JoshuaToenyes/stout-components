chai   = require 'chai'
assert = chai.assert
Button = require './../../Button'



describe 'Button', ->

  button = null
  id = 'button'

  beforeEach ->
    button = new Button label: 'Test Label', id: id
    button.parentEl = document.body

  afterEach ->
    button.destroy()
    button = null

  it 'renders to the document', ->
    button.render()
    assert.ok(document.getElementById(id))
