-- ボタン登録API
function digall_gui.register(name, text, func)
	-- ボタンテーブルに入れる
	digall_gui.buttons[#digall_gui.buttons + 1] = {name, text}

	-- ボタンが押された際の動作
	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname == "digall_gui:mainmenu" then
			if fields[name] then
				func(player, formname, fields)
			end
		end
	end)
end

-- ONOFF用ボタンのテキスト
function digall_gui.check_bool()
	if digall.switch then
		return "Disable DigAll"
	end
	return "Enable DigAll"
end
