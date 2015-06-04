chai   = require 'chai'
assert = chai.assert

describe 'sample test', ->

  it 'should work', ->
    d = document.createElement 'div'
    d.style.backgroundColor = 'black'
    document.body.appendChild(d)
    assert.equal(window.getComputedStyle(d).getPropertyValue('background-color'), 'rgb(0, 0, 0)')
