batteryStatus = require 'node-power-info'

# View to show the battery status in the status bar
class BatteryStatusView extends HTMLDivElement
  tile: null
  backIcon: null
  frontIcon: null
  statusIconContainer: null
  statusText: null
  showRemainingTime: true
  pollingInterval: 60000

  initialize: (@statusBar) ->
    # set css classes for the root element
    @classList.add('battery-status', 'inline-block')

    # create the status-icon div
    @statusIconContainer = document.createElement 'div'
    # @statusIconContainer.classList.add 'inline-block', 'status', 'unknown'
    @appendChild @statusIconContainer

    # create status-icon spans and put then in the icon container
    @backIcon = document.createElement 'span'
    # @backIcon.classList.add 'back-icon', 'icon-battery-unknown'
    @statusIconContainer.appendChild @backIcon

    @frontIcon = document.createElement 'span'
    # @frontIcon.classList.add 'front-icon', 'icon-battery-unknown'
    @statusIconContainer.appendChild @frontIcon

    # create the status-text span
    @statusText = document.createElement 'span'
    # @statusText.classList.add 'inline-block'
    @appendChild @statusText

    # update the view and start the update cycle
    @updateStatus()
    @startPolling()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 0, item: this)

  destroy: ->
    @tile?.destroy()

  startPolling: ->
    if @interval
      clearInterval @interval

    @interval = setInterval =>
        @updateStatus()
      , @pollingInterval

  updateStatus: ->
    # fetch battery percentage and charge status and update the view
    batteryStatus.getDefault()
      .then (provider) => provider.getBatteries()
      .then (batteries) =>
        if batteries.length > 0
          @updateStatusText batteries[0]
          @updateStatusIcon batteries[0]

  updateStatusText: (battery) ->
    if battery.powerLevel?
      # display charge of the first battery in percent (no multi battery support
      # as of now)
      @statusText.textContent = "#{battery.powerLevel}%"
      if @showRemainingTime && battery.isTimeAvailable
        remainingMinutes = ('0' + battery.remainingTimeMinutes).slice -2
        @statusText.textContent += " (#{battery.remainingTimeHours}:#{remainingMinutes})"
    else
      @statusText.textContent = 'error'
      console.warn "Battery Status: invalid charge value: #{battery.powerLevel}"

  updateStatusIcon: (battery) ->
    # clear the class list of the status icon element and re-add basic style
    # classes
    @backIcon.className = ''
    @backIcon.classList.add 'back-icon', 'battery-icon'
    @frontIcon.className = ''
    @frontIcon.classList.add 'front-icon', 'battery-icon'
    @statusIconContainer.className = 'status'

    # add style classes according to charge status
    iconClass = 'icon-battery-unknown';

    if battery.chargeStatus == 'charging' || battery.chargeStatus == 'full'
      iconClass = 'icon-battery-charging'
    else if battery.chargeStatus == 'discharging'
      iconClass = 'icon-battery'

    clip = 'none'
    statusClass = 'unknown'

    if battery.chargeStatus != 'unknown'
      if battery.powerLevel <= 5 && battery.chargeStatus != 'charging'
        iconClass = 'icon-battery-alert'
        statusClass = 'critical'
      else
        if battery.powerLevel <= 10
          statusClass = 'warning'
        else
          statusClass = 'normal'

        clipFull = 23
        clipEmpty = 86
        clipTop = clipFull + ((100 - battery.powerLevel) / 100 * (clipEmpty - clipFull))
        clip = "inset(#{clipTop}% 0 0 0)"

    @statusIconContainer.classList.add statusClass
    @backIcon.classList.add iconClass
    @frontIcon.classList.add iconClass

    # cut the front icon from the top using clip-path
    @frontIcon.setAttribute('style', "clip-path: #{clip}; -webkit-clip-path: #{clip};")

  setShowPercentage: (showPercentage) ->
    if showPercentage
      @statusText.removeAttribute 'style'
    else
      @statusText.setAttribute 'style', 'display: none;'

  setShowRemainingTime: (showRemainingTime) ->
    @showRemainingTime = showRemainingTime
    @updateStatus()

  setOnlyShowInFullscreen: (onlyShowInFullscreen) ->
    if onlyShowInFullscreen
      @classList.add 'hide-outside-fullscreen'
    else
      @classList.remove 'hide-outside-fullscreen'

  setPollingInterval: (pollingInterval) ->
    if pollingInterval
      pollingInterval = Math.max(pollingInterval, 1)
      @pollingInterval = 1000 * pollingInterval
      @startPolling()

module.exports = document.registerElement('battery-status', prototype: BatteryStatusView.prototype)
