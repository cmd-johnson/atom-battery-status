## 0.5.0 - First Release
* Percentage and charge status is being displayed
* Text turns orange when battery drops below 10% and red when < 5%

## 0.9.0 - Icons!
* Removed the status text and replaced it with icons

## 0.10.0 - New backend
* Backed by a different library
* Fixed compatibility issues

## 0.10.2 - Increased polling delay
* Increased polling delay from 1 second to 1 minute
* Fixed a bug where the 'full' battery status wasn't recognized properly

## 0.10.3 - CSS fixes
* Fixed CSS rules for 'full' battery status

## 0.11.0 - Configuration options!
* Added option to only show the status item while Atom is run in full-screen mode
* Added option to show/hide the charge percentage
* Replaced the different svg icons with an icon font
* Slightly improved error handling on unrecognized charge percentages and status texts

## 0.11.1 - Fixed battery icon not being updated properly
* The battery icon should now display correctly after changing from charging to discharging and vice-versa

## 0.11.2 - Configurable polling interval
* Added an option to configure the interval for polling the battery status in seconds

## 0.11.3 - Display estimates on the remaining time
* Added an option for displaying the estimated remaining time until the battery is (dis-)charged on macOS (enabled by default)

## 0.11.4 - Remaining time on linux systems
* Update node-power-info to 1.0.0 to support displaying the remaining time on linux systems

## 0.11.5 - Minor fixes to remaining time calculation on linux
* Update node-power-info to 1.0.1 to fix some time calculation issues on uevent systems

## 0.11.6 - Minor fix to remaining time calculation on linux
* Update node-power-info to 1.0.1 to fix some time calculation issues on uevent systems

## 0.11.6 - Minor fix to remaining time calculation on linux
* Update node-power-info to 1.0.1 to fix handling the uevent edge case of currentPower being zero
