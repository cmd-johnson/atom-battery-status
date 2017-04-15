BatteryStatusView = require './battery-status-view'
{CompositeDisposable} = require 'atom'

module.exports = BatteryStatus =
  batteryStatusView: null
  disposables: null

  config:
    showPercentage:
      order: 1
      type: 'boolean'
      default: true
      description: 'Display the charge percentage next to the charge icon'
    showRemainingTime:
      order: 2
      type: 'boolean'
      default: true
      description: 'Display the estimated remaining time until the battery is (dis-)charged (currently only available on macOS)'
    onlyShowWhileInFullscreen:
      order: 3
      type: 'boolean'
      default: false
      description: 'Display the status item only while in full-screen mode'
    pollingInterval:
      order: 4
      type: 'integer'
      default: 60
      description: 'How many seconds should be waited between updating the battery\'s status'

  activate: ->

  deactivate: ->
    @batteryStatusView?.destroy()
    @batteryStatusView = null
    @disposables?.dispose()

  consumeStatusBar: (statusBar) ->
    @batteryStatusView = new BatteryStatusView()
    @batteryStatusView.initialize(statusBar)
    @batteryStatusView.attach()

    @disposables = new CompositeDisposable
    @disposables.add atom.config.observe 'battery-status.showPercentage', (showPercentage) =>
      @batteryStatusView?.setShowPercentage showPercentage

    @disposables.add atom.config.observe 'battery-status.showRemainingTime', (showRemainingTime) =>
      @batteryStatusView?.setShowRemainingTime showRemainingTime

    @disposables.add atom.config.observe 'battery-status.onlyShowWhileInFullscreen', (onlyShowInFullscreen) =>
      @batteryStatusView?.setOnlyShowInFullscreen onlyShowInFullscreen

    @disposables.add atom.config.observe 'battery-status.pollingInterval', (pollingInterval) =>
      @batteryStatusView?.setPollingInterval pollingInterval
