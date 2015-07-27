battery = require 'node-battery'

# View to show the battery status in the status bar
class BatteryStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('battery-status', 'inline-block')

    @statusIcon = document.createElement 'div'
    @statusIcon.classList.add 'inline-block', 'battery-icon', 'unknown'
    @appendChild @statusIcon

    @statusText = document.createElement 'span'
    @statusText.classList.add 'inline-block'
    @appendChild @statusText

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
    battery.percentages (percentages) =>
      battery.isCharging (charging) =>
        @updateStatusText percentages
        @updateStatusIcon percentages, charging
      , 0
    , 0

  updateStatusText: (percentages) ->
    if percentages? && percentages[0]
      @statusText.textContent = percentages[0] + '%'

  updateStatusIcon: (percentages, charging) ->
    @statusIcon.className = "";
    @statusIcon.classList.add 'inline-block', 'battery-icon'

    if charging?
      if charging[0] == 1
        @statusIcon.classList.add 'charging'
      else if charging[0] == 0
        @statusIcon.classList.add 'discharging'
      else
        @statusIcon.classList.add 'unknown'
        console.log 'unknown charge status: ' + charging[0]

    if percentages? && percentages[0]?
      charge = percentages[0]
      if charge <= 5
        @statusIcon.classList.add 'critical'
      else
        for step in [10..100] by 10
          if charge <= step
            @statusIcon.classList.add 'p' + step
            break

module.exports = document.registerElement('battery-status', prototype: BatteryStatusView.prototype)
