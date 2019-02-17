--
-- Defeat paste blocking
--
hs.hotkey.bind({"cmd", "alt"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)


--
-- Window arrangement
--
hs.window.animationDuration = 0

-- args normalised to 0..1
-- function moveAndResizeWindow(x, y, w, h)
  -- local win = hs.window.focusedWindow()
  -- local screenFrame = win:screen():frame()

  -- local f = win:frame()
  -- f.x = screenFrame.x + screenFrame.w * x
  -- f.y = screenFrame.y + screenFrame.y * y
  -- f.w = screenFrame.w * w
  -- f.h = screenFrame.h * h

  -- win:setFrame(f)
-- end

hs.hotkey.bind({"ctrl", "cmd"}, "h", function()
  hs.window.focusedWindow():moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind({"ctrl", "cmd"}, "l", function()
  hs.window.focusedWindow():moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind({"ctrl", "cmd"}, "j", function()
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  local f = win:frame()
  local rect = hs.geometry.rect(f.x, screenFrame.y + screenFrame.h / 2, f.w, screenFrame.h / 2)
  win:moveToUnit(rect:toUnitRect(screenFrame))
end)

hs.hotkey.bind({"ctrl", "cmd"}, "k", function()
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  local f = win:frame()
  local rect = hs.geometry.rect(f.x, screenFrame.y, f.w, screenFrame.h / 2)
  win:moveToUnit(rect:toUnitRect(screenFrame))
end)

hs.hotkey.bind({"ctrl", "cmd"}, "c", function()
  hs.window.focusedWindow():centerOnScreen()
end)

hs.hotkey.bind({"ctrl", "cmd"}, "f", function()
  hs.window.focusedWindow():toggleFullScreen()
end)

hs.hotkey.bind({"ctrl", "cmd"}, "m", function()
  hs.window.focusedWindow():moveToUnit(hs.layout.maximized)
end)



--
-- Show menu item to warn when Bluetooth batteries need charging.
--
keyboard = hs.menubar.new(false)
mouse    = hs.menubar.new(false)
function checkBluetoothBatteries()
  for i, device in ipairs(hs.battery.otherBatteryInfo()) do
    local menuItem
    local name
    if device.Product == 'Magic Keyboard' then
      menuItem = keyboard
      name = 'Keyboard'
    elseif device.Product == 'Magic Mouse 2' then
      menuItem = mouse
      name = 'Mouse'
    end

    if device.BatteryPercent < 15 then
      menuItem:setTitle(string.format("%s: battery %s%%", name, device.BatteryPercent))
      menuItem:returnToMenuBar()
    else
      menuItem:removeFromMenuBar()
    end
  end
end
-- capture timer to prevent it being garbage collected
batteryTimer = hs.timer.doEvery(300, checkBluetoothBatteries)


--
-- Show sunrise and sunset times in menubar.
--
sun = hs.menubar.new()
sun:setTitle('☀ ')
sun:setTooltip("Sunrise and sunset")
function calculateSunriseSunset()
  lat = 51.7
  long = -1.24
  utc_offset = 0
  format = "%H:%M"
  sunrise = os.date(format, hs.location.sunrise(lat, long, utc_offset))
  sunset  = os.date(format, hs.location.sunset(lat, long, utc_offset))

  sun:setMenu({
    {title = "Sunrise "..sunrise},
    {title = "Sunset  "..sunset},
  })
end
calculateSunriseSunset()
-- capture timer to prevent it being garbage collected
sunTimer = hs.timer.doAt("12:00", "3h", calculateSunriseSunset)
