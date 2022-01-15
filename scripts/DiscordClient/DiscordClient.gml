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

