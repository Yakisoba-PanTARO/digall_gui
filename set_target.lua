-- アルゴリズム一覧(Formspec用テキスト)
local algorithms = ""

local formname = "digall_gui:set_target"

-- algorithmsは可変なためファンクション化
local function formspec()
	return "size[7,4;]"..
		"button[0,0;2,1;back;Back]"..
		"field[2.5,0.5;5,1;target_name;Target Node Name;default:dirt]"..
		"dropdown[2.25,1.25;5,1;algorithm_name;"..algorithms..";1]"..
		"field[2.5,2.7;5,1;argument;Argument;{{x = 3, y = 3, z = 3}}]"..
		"button[0,3.3;7,1;set;Set]"
end

digall_gui.register("set_target", "Set Target", function(player)
	algorithms = ""
	for name, _ in pairs(digall.registered_algorithms) do
		algorithms = (algorithms == "" and name or algorithms..","..name)
	end
	minetest.show_formspec(player:get_player_name(), formname, formspec())
end)

minetest.register_on_player_receive_fields(function(player, receive_formname, fields)
	local name = player:get_player_name()
	if receive_formname == formname then
		if fields.set then
			-- ノード名が間違っている
			if not minetest.registered_nodes[fields.target_name] then
				minetest.chat_send_player(name, "DigAll: Target node doesn't exist.")
			else -- 間違ってない
				minetest.chat_send_player(name, "DigAll: Target Set.")
				digall.register_target(fields.target_name, fields.algorithm_name, minetest.deserialize("return "..fields.argument))
			end
		-- 戻るボタン
		elseif fields.back then
			digall_gui.mainmenu(player)
		end
	end
end)
