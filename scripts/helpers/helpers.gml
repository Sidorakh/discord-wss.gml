/// @description  Gets current Unix timestamp
/// @returns      a unix timestamp
function unix_timestamp() {
	var _old_tz = date_get_timezone();
	date_set_timezone(timezone_utc);
	var _timestamp = floor((date_current_datetime() - 25569) * 86400);
	date_set_timezone(_old_tz);
	return _timestamp;
}

function unix_timestamp_to_gm(time) {
	return (time/86400) + 25569;
}
function gm_timestamp_to_unix(time) {
	return (time - 25569) * 86400;
}
function snowflake_to_unix_timestamp(snowflake) {
	return floor((snowflake/4194304)+1420070400000);
}

function os_get_name() {
	switch (os_type) {
		case os_windows:
		    return "Windows OS";
		break;
		case os_uwp:
		    return "Windows 10 Universal Windows Platform";
		break;
		case os_operagx:
		    return "Opera GX";
		break;
		case os_linux:
		    return "Linux";
		break;
		case os_macosx:
		    return "macOS X";
		break;
		case os_ios:
		    return "iOS (iPhone, iPad, iPod Touch)";
		break;
		case os_tvos:
		    return "Apple tvOS";
		break;
		case os_android:
		    return "Android";
		break;
		case os_ps4:
		    return "Sony PlayStation 4";
		break;
		case os_ps5:
		    return "Sony PlayStation 5";
		break;
		case os_xboxone:
		    return "Microsoft Xbox One";
		break;
		case os_xboxseriesxs:
		    return "Microsoft Xbox Series X/S";
		break;
		case os_switch:
		    return "Nintendo Switch";
		break;
	}
}

function network_send_string(socket,str) {
	var buff = buffer_create(string_length(str),buffer_fixed,1);
	buffer_write(buff,buffer_text,str);
	network_send_raw(socket,buff,buffer_tell(buff));
	buffer_delete(buff);
}

function is_null(v) {
	var _null = (v ?? true);
	return _null == true;
}


function array_find(array,fn) {
	for (var i=0;i<array_length(array);i++) {
		if (fn(array[i]) == true) {
			return array[i];
		}
	}
	return pointer_null;
}

function string_reverse(str) {
	var newstr = "";
	for (var i=string_length(str);i>0;i--) {
		newstr += string_char_at(str,i);	
	}
	return newstr;
}