/// @description 
if (keyboard_check(vk_space)) {
	var cache = string_lower(get_string("Cache to fetch",""));
	var msg = "";
	show_debug_message("fetching " + cache);
	// guild, channel, message, user
	switch (cache) {
		case "guild":
			msg = json_stringify(client.guild_cache);
		break;
		case "channel":
			msg = json_stringify(client.channel_cache);
		break;
		case "message":
			msg = json_stringify(client.message_cache);
		break;
		case "user":
			msg = json_stringify(client.user_cache);
		break;
	}
	show_debug_message(msg);
}

if (keyboard_check(vk_enter)) {
	var channel_id = get_string("Channel","829511733504638986");
	var msg = get_string("Message","I'm too lazy to write a message so I sent the default");
	var channel = client.channel_cache[$ channel_id];
	if (!is_null(channel)) {
		channel.send(msg);
	} else {
		show_message("No channel found with ID " + string(channel_id));	
	}
}