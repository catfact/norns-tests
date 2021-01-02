--- test device detection

local hid = require 'hid'

local keycodes = include("lib/keycodes")

engine.name = 'None'

init = function ()
    print('hello HID class detection')
end 