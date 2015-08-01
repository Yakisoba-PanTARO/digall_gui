local formname = "digall_gui:remove_target"
local formspec = "size[7,2;]"..
	"button[0,0;2,1;back;Back]"..
	"field[3,0.5;4,1;target_name;Target Node Name;default:dirt]"..
	"button[0,1.1;7,1;remove;Remove]"

digall_gui.register("remove_target", "Remove Target", function(player)
	minetest.show_formspec(player:get_player_name(), formname, formspec)
end)

minetest.register_on_player_receive_fields(function(player, receive_formname, fields)
	local name = player:get_player_name()
	if receive_formname == formname then
		if fields.remove then
			-- 登録されてたら実行
			if digall.registered_targets[fields.target_name] then
				digall.remove_target(fields.target_name)
				minetest.chat_send_player(name, "DigAll: Target Removed.")
			-- 登録されてない場合
			else
				minetest.chat_send_player(name, "DigAll: Target node doesn't register.")
			end
		-- 戻る（Back）ボタン
		elseif fields.back then
			digall_gui.mainmenu(player)
		end
	end
end)
