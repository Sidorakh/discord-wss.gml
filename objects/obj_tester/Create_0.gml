/// @description 


var buff = buffer_load("discord-token.txt");
token = buffer_read(buff,buffer_text);
buffer_delete(buff);
client = create_discord_client(token, DISCORD_INTENTS.GUILDS | DISCORD_INTENTS.GUILD_MESSAGES | DISCORD_INTENTS.GUILD_MEMBERS);


client.on("MESSAGE_CREATE",function(msg){
	//show_message(json_stringify(msg));
	if (msg.author.bot) return;
	msg.channel.send(string_reverse(msg.content));
});