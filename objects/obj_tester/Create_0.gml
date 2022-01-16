/// @description 


var buff = buffer_load("discord-token.txt");
token = buffer_read(buff,buffer_text);
buffer_delete(buff);
client = create_discord_client(token, DISCORD_INTENTS.GUILDS | DISCORD_INTENTS.GUILD_MESSAGES | DISCORD_INTENTS.GUILD_MEMBERS);

stored_interaction = pointer_null;

client.on("MESSAGE_CREATE",function(msg){
	//show_message(json_stringify(msg));
	if (msg.author.bot) return;
	msg.channel.send(string_reverse(msg.content));
});

client.on("INTERACTION_CREATE",function(interaction){
	//interaction.defer();
	//alarm[0] = 30;
	//stored_interaction = interaction;
	show_debug_message(json_stringify(interaction));
	switch (interaction.name) {
		case "trace":
			interaction.respond(interaction.cmd.options.message.value);
		break;
		case "mathematics":
			if (!is_null(interaction.cmd.options[$ "add"])) {
				var first = real(interaction.cmd.options.add.options.first.value);
				var second = real(interaction.cmd.options.add.options.second.value);
				interaction.respond(string(first) + " + " + string(second) + " = " + string(first+second));
			}
			if (!is_null(interaction.cmd.options[$ "multiply"])) {
				var first = real(interaction.cmd.options.multiply.options.first.value);
				var second = real(interaction.cmd.options.multiply.options.second.value);
				interaction.respond(string(first) + " * " + string(second) + " = " + string(first*second));
			}
		break;
		default:
			interaction.respond(json_stringify(interaction.cmd.data));
		break;
	};
	
});