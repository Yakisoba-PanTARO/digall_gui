local formname = "digall_gui:set_range"
local formspec = "size[7,2;]"..
	"button[0,0;2,1;back;Back]"..
	"field[3,0.5;1,1;range_x;X;3]"..
	"field[4,0.5;1,1;range_y;Y;3]"..
	"field[5,0.5;1,1;range_z;Z;3]"..
	"button[0,1.1;7,1;set;Set]"

digall_gui.register("set_range", "Set Default Range", function(player)
	minetest.show_formspec(player:get_player_name(), formname, formspec)
end)

minetest.register_on_player_receive_fields(function(player, receive_formname, fields)
	local name = player:get_player_name()
	if receive_formname == formname then
		if fields.set then
			local x = tonumber(fields.range_x)
			local y = tonumber(fields.range_y)
			local z = tonumber(fields.range_z)
			if type(x) ~= "number"
			or type(y) ~= "number"
			or type(z) ~= "number" then
				minetest.chat_send_player(name, "DigAll: Range is incorrect.")
			else
				minetest.chat_send_player(name, "DigAll: Range Set.")
				digall.set_default_range({vector.new(x,y,z)})
			end
		elseif fields.back then
			digall_gui.mainmenu(player)
		end
	end
end)
