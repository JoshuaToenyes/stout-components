


class Transform

  constructor: (@_el) ->
    @_transforms = []

  _push: (transform) ->
    m = new RegExp transform.substring(0, transform.indexOf('('))
    for t, i in @_transforms
      if t.match m then @_transforms.splice(i, 1)
    @_transforms.push transform
    @_write()

  _write: ->
    t = @_transforms.join ' '
    @_el.style.webkitTransform = t
    @_el.style.mozTransform = t
    @_el.style.msTransform = t
    @_el.style.oTransform = t
    @_el.style.transform = t

  matrix: ->

  translate: (x, y) ->

  translateX: (x) ->

  translateY: (y) ->

  translateZ: (z) ->

  translate3d: (x, y, z) ->

  scale: (x, y) ->

  scaleX: (x) ->

  scaleY: (y) ->

  skewX: (x) ->

  skewY: (y) ->

  matrix3d: ->

  scale3d: ->

  scaleZ: ->

  rotate: (r) ->
    @_push "rotate(#{r})"

  rotate3d: ->

  rotateX: (x) ->

  rotateY: (y) ->

  rotateZ: (z) ->

  perspective: ->

  origin: ->

  originX: ->

  originY: ->

  originZ: ->


module.exports = (el) ->
  new Transform el
