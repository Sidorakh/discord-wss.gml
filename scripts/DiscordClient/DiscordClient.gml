global.DISCORD_GATEWAY_URL = "wss://gateway.discord.gg/?v=9&encoding=json";
global.DISCORD_GATEWAY_PORT = 443;
global.DISCORD_API_URL = "https://discord.com/api/v9";
#macro DISCORD_API (global.DISCORD_API_URL)

function create_discord_client(_token,_intents) {
	var _handler = instance_create_depth(0,0,0,obj_discord);
	_handler.token = _token;
	_handler.intents = _intents;
	_handler.initialize();
	return _handler;
}

function DiscordGuild(_d) constructor {
	_id = _d.id;
	name = _d.name;
	nsfw = _d.nsfw;
	owner_id = _d.owner_id;
	channels = [];
	for (var i=0;i<array_length(_d.channels);i++) {
		array_push(channels,_d.channels[i].id);
	}
}

function DiscordMessage(d,_channel=undefined,_author=undefined,_member=undefined,_client=noone) constructor {
	client = _client;
	_id = d.id;
	content = d.content;
	channel_id = d.channel_id;
	author_id = d.author.id;
	channel = _channel;
	author = _author;
	member = _member;
	
	
}

function DiscordChannel(_d,_guild_id=noone,_client=noone) constructor {
	client = _client;
	_id = _d.id;
	name = _d.name;
	is_nsfw = _d[$ "nsfw"] ?? false;
	type = _d.type;
	parent = _d[$ "parent_id"] ?? pointer_null;
	guild_id = _d[$ "guild_id"] ?? _guild_id;
	function send(msg) {
		if (is_string(msg)) {
			msg = {
				content: msg,
			}
		}
		var url = DISCORD_API + "/channels/" + string(_id) + "/messages";
		show_debug_message(url);
		http(url,"POST",msg,client.http_options,function(status,result){
			//show_message(result);
		});
	}
}

function DiscordInteraction(_cmd,_client) constructor {
	client = _client;
	cmd_data = _cmd;
	app_id = cmd_data.application_id;
	interaction_id = cmd_data.id;
	token = cmd_data.token;
	data = cmd_data.data;
	name = data.name;
	cmd = new DiscordInteractionResponseOptions(data);
	
	function defer(flags=0,cb=undefined) {
		var url = DISCORD_API + "/interactions/"+string(interaction_id) + "/" + string(token) + "/callback";
		var body = {
			type: DISCORD_INTERACTION_RESPONSE.DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE,
		}
		var http_options = struct_copy(client.http_options);
		http_options.callback = cb;
		http(url,"POST",body,http_options,function(status,result,options){
			show_message_async("Defer response: " + result);
			if (!is_null(options.callback)) {
				options.callback();
			}
		});
	}
	function update(msg,cb=undefined) {
		var url = DISCORD_API + "/webhooks/" + string(app_id) + "/" + string(token) + "/messages/@original";
		var body = {};
		if (is_struct(msg)) {
			body  = msg;
		} else {
			body = {content: msg};	
		}
		var http_options = struct_copy(client.http_options);
		http_options.callback = cb;
		http(url,"PATCH",body,http_options,function(status,result,options){
			show_message_async("Update response: " + result);
			if (!is_null(options.callback)) {
				options.callback();
			}
		});
	}
	function respond(msg,flags=0,cb=undefined) {
		var url = DISCORD_API + "/interactions/"+string(interaction_id) + "/" + string(token) + "/callback";
		var body = {
			type: DISCORD_INTERACTION_RESPONSE.CHANNEL_MESSAGE_WITH_SOURCE,
			flags: flags,
		};
		if (!is_struct(msg)) {
			body.data = {content: msg};
		} else {
			body.data = msg;	
		}
		var http_options = struct_copy(client.http_options);
		http_options.callback = cb;
		http(url,"POST",body,http_options,function(status,result,options){
			show_message_async("Respond response: " + result);
			if (!is_null(options.callback)) {
				options.callback();	
			}
		});
	}
}

function DiscordInteractionResponseOptions(_data) constructor {
	type = _data.type;
	name  = _data.name;
	options = {};
	value = pointer_null;
	if (type == DISCORD_INTERACTION_DATA_TYPE.SUB_COMMAND) {
		for (var i=0;i<array_length(_data.options);i++) {
			options[$ _data.options[i].name] = new DiscordInteractionResponseOptions(_data.options[i]);
		}
	} else {
		value = _data.value;
	}
}

//function parse_iso_timestamp(iso_time) {
//	// 2022-01-14T11:28:00.291000+00:00
//	var year = real(string_copy(iso_time,1,4));
//	var month = real(string_copy(iso_time,6,2));
//	var day = real(string_copy(iso_time,9,2);
//	var hour = 11
	
//}

/*

export function convertSnowflakeToDate(snowflake, epoch = DISCORD_EPOCH) {
	return new Date(snowflake / 4194304 + epoch)
}

export const DISCORD_EPOCH = 1420070400000

*/

