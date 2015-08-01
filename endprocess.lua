-- 機能一覧Formspecの幅（不変）
local x = 4
-- 機能一覧Formspecの高さ（ボタンの個数によって増やされる）
local y = 0.8
-- 機能一覧Formspec用の変数
local formspec = ""

minetest.after(0,function()
	-- 登録されたボタンをFormspec化
	for _, def in ipairs(digall_gui.buttons) do
		formspec = formspec.."button[0,"..y..";"..x..",1;"..def[1]..";"..def[2].."]"
		-- 高さを増やす
		y = y+0.8
	end
end)

-- メインメニュー表示ファンクション
function digall_gui.mainmenu(player)
	minetest.show_formspec(player:get_player_name(), "digall_gui:mainmenu",
		"size["..x..","..y..";]"..
		formspec..
		"button[0,0;"..x..",1;switch;"..(digall.switch and "Disable DigAll" or "Enable DigAll").."]"
	)
end

-- ONOFF切り替えボタンの動作
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if formname == "digall_gui:mainmenu" then
		if fields.switch then
			minetest.chat_send_player(name, (digall.switch and "DigAll: Disabled." or "DigAll: Enabled."))
			digall.switch = (not digall.switch and true or false)
			digall_gui.mainmenu(player)
		end
	end
end)

-- Inventory Plus用の動作
if minetest.get_modpath("inventory_plus") then
	-- ボタンをInventory Plusに登録
	minetest.register_on_joinplayer(function(player)
		inventory_plus.register_button(player, "digall_gui", "DigAll")
	end)

	-- Inventory Plusのボタンが押された際の動作
	minetest.register_on_player_receive_fields(function(player, _, fields)
		if fields.digall_gui then
			digall_gui.mainmenu(player)
		end
	end)
end
