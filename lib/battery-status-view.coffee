# battery = require 'node-battery'
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
      if batteryStats.length >== 1
        batStats = batteryStats[0]
        @updateStatusText batStats.powerLevel
        @updateStatusIcon batStats.powerLevel, batStats.chargeStatus

    # battery.percentages (percentages) =>
    #   battery.isCharging (charging) =>
    #     @updateStatusText percentages
    #     @updateStatusIcon percentages, charging
    #   , 0
    # , 0

  updateStatusText: (percentages) ->
    if percentages? && percentages[0]
      # display charge of the first battery in percent (no multi battery support
      # as of now)
      @statusText.textContent = percentages[0] + '%'

  updateStatusIcon: (percentages, charging) ->
    # clear the class list of the status icon element and re-add basic style
    # classes
    @statusIcon.className = "";
    @statusIcon.classList.add 'inline-block', 'battery-icon'

    # add style classes according to charge status
    if charging?
      if charging[0] == 1
        @statusIcon.classList.add 'charging'
      else if charging[0] == 0
        @statusIcon.classList.add 'discharging'
      else
        @statusIcon.classList.add 'unknown'
        console.log 'unknown charge status: ' + charging[0]

    # add style classes according to the power level of the battery
    if percentages? && percentages[0]?
      charge = percentages[0]
      if charge <= 5
        @statusIcon.classList.add 'critical'
      else
        # there are style classes for every 10% step (p10 to p100), so set one
        # of those classes accordingly
        for step in [10..100] by 10
          if charge <= step
            @statusIcon.classList.add 'p' + step
            break

module.exports = document.registerElement('battery-status', prototype: BatteryStatusView.prototype)
