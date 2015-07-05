encodingStatusView = null

module.exports =
  activate: ->

  deactivate: ->
    encodingStatusView?.destroy()
    encodingStatusView = null

  consumeStatusBar: (statusBar) ->
    BatteryStatusView = require './battery-status-view'
    batteryStatusView = new BatteryStatusView()
    batteryStatusView.initialize(statusBar)
    batteryStatusView.attach()
