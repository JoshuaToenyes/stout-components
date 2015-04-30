ProgressBar = require './index'

window.bar = new ProgressBar numeric: true, symbol: '', init: Math.random()
bar.el = document.getElementById('demo')

bar.render()
