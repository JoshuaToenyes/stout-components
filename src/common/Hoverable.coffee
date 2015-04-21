
Component = require './Component'

STATE =
  DEFAULT: 1  # Normal static state.
  HOVER:   2  # Mouse is over the button.
  ACTIVE:  3  # Mouse is down over button.
  FOCUS:   4  # Button is focused.

module.exports = class Hoverable extends Component

  @property 'hoverState'

  constructor: (template, model, opts, @_hoverFn) ->
    super template, model, opts
    @registerEvents 'hover leave active focus'
    @_hoverTimer = null
    @_state = STATE.DEFAULT

  render: ->
    super()

    self = @

    b = @_hoverFn.call @

    b.addEventListener 'click', (e) ->
      self.fire 'click', e

    b.addEventListener 'mousedown', (e) ->
      self.fire 'active', e

    b.addEventListener 'focus', (e) ->
      self.fire 'focus', e

    b.addEventListener 'mouseenter', (e) ->
      clearTimeout self._hoverTimer
      if self._state is STATE.HOVER then return
      self._state = STATE.HOVER
      self.fire 'hover', e

    b.addEventListener 'mouseleave', (e) ->
      self._hoverTimer = setTimeout ->
        self._state = STATE.DEFAULT
        self.fire 'leave', e
      , 10
