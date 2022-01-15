/// @description 
if (async_load[? "id"] != socket) return;


switch (async_load[? "type"]) {
	case network_type_connect:
		//show_message("network_type_connect");
	break;
	case network_type_disconnect:
		//show_message("network_type_disconnect");
	break;
	case network_type_non_blocking_connect:
		//show_message("network_type_non_blocking_connect");
	break;
	case network_type_data:
		//show_message("network_type_data");
		var packet = buffer_read(async_load[? "buffer"],buffer_text);
		packet = json_parse(packet);
		var data = packet.d;
		last_sequence = packet.s;
		switch (packet.op) {
			case DISCORD_OPCODE.HELLO:
				heartbeat_interval = data.heartbeat_interval;
				next_heartbeat(heartbeat_interval * random(1))
				send_identify();
			break;
			case DISCORD_OPCODE.HEARTBEAT_ACK:
				// heartbeat acknowledged
			break;
			case DISCORD_OPCODE.DISPATCH:
				// handle dispatch!
				handle_dispatch(packet);
			break;
			case DISCORD_OPCODE.INVALID_SESSION:
			case DISCORD_OPCODE.RECONNECT:
				send_identify();
			break;
			default: 
				show_debug_message(json_stringify(packet));
		}
	break;
}