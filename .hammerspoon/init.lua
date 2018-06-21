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
batteryTimer = hs.timer.doEvery(300, checkBluetoothBatteries)

