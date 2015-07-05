battery = require 'node-battery'

# style classes set when percentage drops below warning threshold
warningClasses = ['warning']
# style classes set when percentage drops below critical threshold
criticalClasses = ['critical', 'icon', 'icon-issue-opened']

# View to show the battery status in the status bar
class BatteryStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('battery-status', 'inline-block')
    @statusText = document.createElement('span')
    @statusText.classList.add('inline-block')
    @statusText.textContent = 'initializing battery status...'
    @appendChild(@statusText)
    @update()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 0, item: this)

  destroy: ->
    @tile?.destroy()

  update: ->
    setInterval =>
        @updateStatusText()
      , 5000

  updateStatusText: ->
    battery.percentages (percentages) =>
      battery.isCharging (charging) =>
        @statusText.textContent = percentages[0] + '%, '
        if charging[0] == 0
          @statusText.textContent += 'discharging'
        else
          @statusText.textContent += 'charging'
      , 0

      @removeStyleClasses(warningClasses)
      @removeStyleClasses(criticalClasses)

      if percentages[0] <= 5
        @addStyleClasses(criticalClasses)
      else if percentages[0] <= 10
        @addStyleClasses(warningClasses)
    , 0

  removeStyleClasses: (classes) ->
    for c in classes
      @statusText.classList.remove(c)

  addStyleClasses: (classes) ->
    for c in classes
      @statusText.classList.add(c)

module.exports = document.registerElement('battery-status', prototype: BatteryStatusView.prototype)
