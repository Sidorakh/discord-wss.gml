/// @description 
token = "";
intents = 0;
socket = network_create_socket(network_socket_wss);
network_connect_raw(socket,global.DISCORD_GATEWAY_URL,global.DISCORD_GATEWAY_PORT);

http_headers = ds_map_create();
http_options = {
	headers: http_headers,
	keep_header_map: true,
}

heartbeat_interval = 0;
last_sequence = pointer_null;

guild_cache = {};
channel_cache = {};
user_cache = {};
message_cache = {};

handlers = event_map();	// create new event map

function initialize() {
	// Set up auth token
	http_headers[? "Authorization"] = "Bot " + token;
}

function on(event,cb) {
	var new_cb = {
		cb: cb,
		type: "on"
	}
	var index = array_length(handlers[$ event]);
	array_push(handlers[$ event],new_cb);
}

function once(event,cb) {
	var new_cb = {
		cb: cb,
		type: "once",
	}
	var index = array_length(handlers[$ event]);
	array_push(handlers[$ event],new_cb);
}

function off(event,index) {
	handlers[$ event] = undefined;
}

function next_heartbeat(in) {
	alarm[0] = floor((in/1000)*game_get_speed(gamespeed_fps));
}

function send_heartbeat() {
	var packet = {
		op: DISCORD_OPCODE.HEARTBEAT,
		d: last_sequence,
	};
	packet = json_stringify(packet);
	network_send_string(socket,packet);
}

function send_identify() {
	var _os_name = os_get_name();
	
	
	var _os_info = {};
	_os_info[$ "$os"] = _os_name;
	_os_info[$ "$browser"] = "discord-wss.gml";
	_os_info[$ "$device"] = "discord-wss.gml";
	
	
	var packet = {
		op: DISCORD_OPCODE.IDENTIFY,
		d: {
			token: token,
			intents: intents,
			properties: _os_info
		}
	}
	packet = json_stringify(packet);
	network_send_string(socket,packet);
}



function handle_dispatch(packet) {
	var type = packet.t;
	show_debug_message(type);
	switch (type) {
		case "READY":
			dispatch_ready(packet);
		break;
		case "GUILD_CREATE":
			guild_create(packet);
		break;
		case "MESSAGE_CREATE":
			on_message_create(packet.d)
		break;
		
	}
}

function register_channel(channel,guild_id="") {
	
}

function update_user(data) {
	var _id = data.id;
	if (user_cache[$ _id] == undefined) {
		user_cache[$ _id] = {};	
	}
	user_cache[$ _id].username = data.username;
	user_cache[$ _id].discriminator = data.discriminator;
	user_cache[$ _id].avatar = data.avatar;
	user_cache[$ _id].bot = data[$ "bot"] ?? false;
	var _avatar_url = "https://cdn.discordapp.com"
	if (is_null(user_cache[$ _id].avatar)) {
		// this means it's a default avatar!
		_avatar_url += "/embed/avatars/" + string(real(data.discriminator) % 5) + ".png"
	} else {
		_avatar_url += "/avatars/" + _id + "/" + data.avatar;
		if (string_pos("_a",data.avatar) != 0) {
			_avatar_url += ".gif";
		} else {
			_avatar_url += ".png";	
		}
	}
	user_cache[$ _id].avatar_url = _avatar_url;
}

function guild_create(packet) {
	var guild = new DiscordGuild(packet.d,self);
	guild_cache[$ guild._id] = guild;
	for (var i=0;i<array_length(packet.d.channels);i++) {
		var channel = new DiscordChannel(packet.d.channels[i],guild._id,id);
		channel_cache[$ channel._id] = channel;
	}
}

function dispatch_ready(packet) {
	var data = packet.d;
	// eh not much to do here
}

function on_message_create(msg) {
	show_debug_message(json_stringify(msg));
	update_user(msg.author);
	var message = new DiscordMessage(msg,channel_cache[$ msg.channel_id],user_cache[$ msg.author.id],undefined,id);
	
	message_cache[$ message._id] = message;
	for (var i=0;i<array_length(handlers.MESSAGE_CREATE);i++) {
		var fn = handlers.MESSAGE_CREATE[i];
		if (!is_null(fn)) {
			fn.cb(message);
			if (fn.type == "once") {
				handlers.MESSAGE_CREATE[i] = undefined;	
			}
		}
	}
}
