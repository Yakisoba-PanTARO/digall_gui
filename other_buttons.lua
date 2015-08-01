-- すべてのノードを自動設定
digall_gui.register("set_default_targets", "Set Default Targets", function(player, formname, fields)
	digall.set_default_target_setting()
	minetest.chat_send_player(player:get_player_name(), "DigAll: Default Targets Set.")
end)

-- ターゲットを全削除
digall_gui.register("clear_targets", "Clear Targets", function(player, formname, fields)
	digall.clear_target_setting()
	minetest.chat_send_player(player:get_player_name(), "DigAll: Targets Cleared.")
end)
