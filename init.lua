-- TODO: show_formspecを潰す

-- Formspec表示
local function show_formspec(name, mode)
	-- Mode1:機能一覧
	if mode == 1 then
		-- DigAllの状態でテキスト変化
		local modetext = "Enable DigAll"
		if digall.switch then
			modetext = "Disable DigAll"
		end
		-- Formspec表示
		minetest.show_formspec(name, "digall:setting",
			"size[3,4.8;]"..
			"button[0,0;3,1;switch;"..modetext.."]"..
			"button[0,0.8;3,1;set_target;Set Target]"..
			"button[0,1.6;3,1;remove_target;Remove Target]"..
			"button[0,2.4;3,1;set_default_targets;Set Default Targets]"..
			"button[0,3.2;3,1;clear_targets;Clear Targets]"..
			"button[0,4;3,1;set_range;Set Default Range]"
		)
	-- Mode2:ターゲット設定(追加)
	elseif mode == 2 then
		minetest.show_formspec(name, "digall:set_target",
			"size[7,4;]"..
			"button[0,0;2,1;back;Back]"..
			"field[3,0.5;4,1;target_name;Target Node Name;default:dirt]"..
			"field[3,1.6;4,1;algorithm_name;Algorithm Name;digall:default]"..
			"field[3,2.7;4,1;argument;Argument;{{x = 3, y = 3, z = 3}}]"..
			"button[0,3.3;7,1;set;Set]"
		)
	-- Mode3:ターゲット削除
	elseif mode == 3 then
		minetest.show_formspec(name, "digall:remove_target",
			"size[7,2;]"..
			"button[0,0;2,1;back;Back]"..
			"field[3,0.5;4,1;target_name;Target Node Name;default:dirt]"..
			"button[0,1.1;7,1;remove;Remove]"
		)
	-- Mode4:範囲変更
	elseif mode == 4 then
		minetest.show_formspec(name, "digall:set_range",
			"size[7,2;]"..
			"button[0,0;2,1;back;Back]"..
			"field[3,0.5;1,1;range_x;X;3]"..
			"field[4,0.5;1,1;range_y;Y;3]"..
			"field[5,0.5;1,1;range_z;Z;3]"..
			"button[0,1.1;7,1;set;Set]"
		)
	end
end

-- Formspecのボタンによる動作
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	-- Inventory Plusのボタンが押された際表示
	if fields.digall_settings then
		show_formspec(name,1)
	end
	-- 機能一覧
	if formname == "digall:setting" then
		-- ONOFF切り替え
		if fields.switch then
			if digall.switch then
				digall.switch = false
				minetest.chat_send_player(name, "DigAll: Disabled.")
			else
				digall.switch = true
				minetest.chat_send_player(name, "DigAll: Enabled.")
			end
			show_formspec(name, 1)
		-- Mode2(ターゲット設定メニュー)表示
		elseif fields.set_target then
			show_formspec(name, 2)
		-- Mode3(ターゲット削除メニュー)表示
		elseif fields.remove_target then
			show_formspec(name, 3)
		-- ターゲットの自動登録
		elseif fields.set_default_targets then
			digall.set_default_target_setting()
			minetest.chat_send_player(name, "DigAll: Default Targets Set.")
		-- ターゲットを全削除
		elseif fields.clear_targets then
			digall.clear_target_setting()
			minetest.chat_send_player(name, "DigAll: Targets Cleared.")
		-- Mode4(範囲変更メニュー)表示
		elseif fields.set_range then
			show_formspec(name, 4)
		end
	-- ターゲット設定(追加)
	elseif formname == "digall:set_target" then
		if fields.set then
			-- フラグ 何かのパラメータが間違っていればフラグはへし折られる
			local can_set = true
			-- ノード名が間違っている
			if not minetest.registered_nodes[fields.target_name] then
				can_set = false
				minetest.chat_send_player(name, "DigAll: Target node doesn't exist.")
			end
			-- アルゴリズム名が間違っている
			if not digall.registered_algorithms[fields.algorithm_name] then
				can_set = false
				minetest.chat_send_player(name, "DigAll: Specified algorithm doesn't exist.")
			end
			-- can_setがtrueのままだったら登録
			if can_set then
				minetest.chat_send_player(name, "DigAll: Target Set.")
				digall.register_target(fields.target_name,fields.algorithm_name,minetest.deserialize("return "..fields.argument))
			end
		-- 戻る（Back）ボタン
		elseif fields.back then
			show_formspec(name, 1)
		end
	-- ターゲット削除
	elseif formname == "digall:remove_target" then
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
			show_formspec(name, 1)
		end
	-- 範囲変更
	elseif formname == "digall:set_range" then
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
		-- 戻る（Back）ボタン
		elseif fields.back then
			show_formspec(name, 1)
		end
	end
end)

-- コマンド
minetest.register_chatcommand("digall:setting", {
	description = "DigAll Settings",
	func = function(name)
		-- すぐに実行してもコマンドメニューが閉じきってないので表示されない
		minetest.after(0.1,function()
			show_formspec(name, 1)
		end)
	end
})

-- Inventory Plusにショートカットを登録
if minetest.get_modpath("inventory_plus") then
	minetest.register_on_joinplayer(function(player)
		inventory_plus.register_button(player,"digall_settings","DigAll")
	end)
end
