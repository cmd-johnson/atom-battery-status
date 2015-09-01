batteryStatus = require 'node-power-info'

# View to show the battery status in the status bar
class BatteryStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    # set css classes for the root element
    @classList.add('battery-status', 'inline-block')

    # create the status-icon div
    @statusIcon = document.createElement 'div'
    @statusIcon.classList.add 'inline-block', 'battery-icon', 'unknown'
    @appendChild @statusIcon

    # create the status-text span
    @statusText = document.createElement 'span'
    @statusText.classList.add 'inline-block'
    @appendChild @statusText

    # update the view and start the update cycle
    @updateStatus()
    @update()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 0, item: this)

  destroy: ->
    @tile?.destroy()

  update: ->
    setInterval =>
        @updateStatus()
      , 1000

  updateStatus: ->
    # fetch battery percentage and charge status and update the view
    batteryStatus.getChargeStatus (batteryStats) =>
      if batteryStats.length >= 1
        batStats = batteryStats[0]
        @updateStatusText batStats.powerLevel
        @updateStatusIcon batStats.powerLevel, batStats.chargeStatus

  updateStatusText: (percentage) ->
    if percentage?
      # display charge of the first battery in percent (no multi battery support
      # as of now)
      @statusText.textContent = percentage + '%'

  updateStatusIcon: (percentage, chargeStatus) ->
    # clear the class list of the status icon element and re-add basic style
    # classes
    @statusIcon.className = "";
    @statusIcon.classList.add 'inline-block', 'battery-icon'

    # add style classes according to charge status
    if chargeStatus?
      if chargeStatus == 'charging' || chargeStatus == ''
        @statusIcon.classList.add 'charging'
      else if chargeStatus == 'discharging'
        @statusIcon.classList.add 'discharging'
      else if chargeStatus == 'full'
        @statusIcon.classList.add 'full'
      else
        @statusIcon.classList.add 'unknown'
        if chargeStatus != 'unknown'
          console.log 'unknown charge status: ' + chargeStatus

    # add style classes according to the power level of the battery
    if percentage?
      if percentage <= 5
        @statusIcon.classList.add 'critical'
      else
        # there are style classes for every 10% step (p10 to p100), so set one
        # of those classes accordingly
        for step in [10..100] by 10
          if percentage <= step
            @statusIcon.classList.add 'p' + step
            break

module.exports = document.registerElement('battery-status', prototype: BatteryStatusView.prototype)
