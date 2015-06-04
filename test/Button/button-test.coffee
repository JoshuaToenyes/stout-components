chai   = require 'chai'
assert = chai.assert
Button = require './../../Button'
$      = require '/Users/josh/work/stout/client/$'


describe 'Button', ->

  button = null
  id = 'button'
  label = 'Test Label'

  beforeEach ->
    button = new Button label: label, id: id
    button.parentEl = document.body

  afterEach ->
    if button.rendered then button.destroy()
    button = null

  it 'has a #label property', ->
    assert.property button, 'label'

  it 'the #label property defaults to the empty string', ->
    b = new Button
    assert.equal('', b.label)

  it 'overrides the #show() method', ->
    assert.ok(Button.prototype.hasOwnProperty 'show')

  it 'overrides the #hide() method', ->
    assert.ok(Button.prototype.hasOwnProperty 'hide')

  it 'renders to the document', ->
    button.render()
    assert.ok(document.getElementById(id))


  describe '#label', ->

    beforeEach ->
      button.render()

    it 'updates on the button when changed', ->
      assert.equal(button.label, label)
      newLabel = 'Changed Label'
      button.label = newLabel
      assert.equal(button.label, newLabel)
      assert.equal(document.querySelector('button').textContent, newLabel)


  describe '#isVisible()', ->

    it 'returns false before rendered', ->
      assert.isFalse button.isVisible()

    it 'returns true after renderd', ->
      button.render()
      assert.isTrue button.isVisible()

    it 'returns correctly after cycling visibility', ->
      assert.isFalse button.isVisible()
      button.render()
      assert.isTrue button.isVisible()
      button.hide()
      assert.isFalse button.isVisible()
      button.show()
      assert.isTrue button.isVisible()



  describe '#show()', ->

    it 'adds the .sc-fill class to the button', ->
      button.render()
      button.hide()
      assert.isFalse($('button').hasClass 'sc-fill')
      button.show()
      assert.isTrue($('button').hasClass 'sc-fill')


  describe '#hide()', ->

    it 'removes the .sc-fill class to the button', ->
      button.render()
      assert.isTrue($('button').hasClass 'sc-fill')
      button.hide()
      assert.isFalse($('button').hasClass 'sc-fill')
