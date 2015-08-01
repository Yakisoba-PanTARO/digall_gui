digall_gui = {}
digall_gui.buttons = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())

-- *API
dofile(modpath.."/api.lua")

-- Buttons
dofile(modpath.."/set_target.lua")
dofile(modpath.."/remove_target.lua")
dofile(modpath.."/set_range.lua")
dofile(modpath.."/other_buttons.lua")

-- *End Process(?)
dofile(modpath.."/endprocess.lua")
