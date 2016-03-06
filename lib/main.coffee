BatteryStatusView = require './battery-status-view'
{CompositeDisposable} = require 'atom'

module.exports = BatteryStatus =
  batteryStatusView: null
  disposables: null

  config:
    showPercentage:
      type: 'boolean'
      default: true
      description: 'Display the charge percentage next to the charge icon'

  activate: ->

  deactivate: ->
    @batteryStatusView?.destroy()
    @batteryStatusView = null

  consumeStatusBar: (statusBar) ->
    @batteryStatusView = new BatteryStatusView()
    @batteryStatusView.initialize(statusBar)
    @batteryStatusView.attach()

    @disposables = new CompositeDisposable
    @disposables.add atom.config.observe 'battery-status.showPercentage', (showPercentage) =>
      @batteryStatusView?.setShowPercentage showPercentage
