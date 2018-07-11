/**********************
 * AWW SHIT IT'S TIME FOR RADIO
 *
 * Concept stolen from D2K5
 *
 * Rewritten by N3X15
 ***********************/

// Uncomment to test the mediaplayer
//#define DEBUG_MEDIAPLAYER

// Open up VLC and play musique.
// Converted to VLC for cross-platform and ogg support. - N3X
var/const/PLAYER_HTML={"
<embed type="application/x-vlc-plugin" pluginspage="http://www.videolan.org" />
<object classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codebase="http://download.videolan.org/pub/videolan/vlc/last/win32/axvlc.cab" id="player"></object>
	<script>
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var vlc = document.getElementById('player');

	// Stop playing
	vlc.playlist.stop();

	// Clear playlist
	vlc.playlist.items.clear();

	// Add new playlist item.
	var id = vlc.playlist.add(url);

	// Play playlist item
	vlc.playlist.playItem(id);

	vlc.input.time = time*1000; // VLC takes milliseconds.
	vlc.audio.volume = volume*100; // \[0-200]
}
	</script>
"}

/* OLD, DO NOT USE.  CONTROLS.CURRENTPOSITION IS BROKEN.*/
/*var/const/PLAYER_OLD_HTML={"
	<OBJECT id='playerwmp' CLASSID='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' type='application/x-oleobject'></OBJECT>
	<script>
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var player = document.getElementById('playerwmp');
	player.URL = url;
	player.controls.currentPosition = time;
	player.settings.volume = volume;
}
	</script>"}

*/

var/const/PLAYER_OLD_HTML={"
	<OBJECT id='player' CLASSID='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' type='application/x-oleobject'></OBJECT>
	<script>
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var player = document.getElementById('player');
	player.URL = url;
	player.Controls.currentPosition = +time;
	player.Settings.volume = +volume;
}
	</script>"}

/mob/proc/stop_all_music()
	var/datum/component/media_manager/MM = GetComponent(/datum/component/media_manager)
	MM.stop_music()

/mob/proc/force_music(var/url,var/start,var/volume=1)
	var/datum/component/media_manager/MM = GetComponent(/datum/component/media_manager)
	MM.forced = (url != "")
	if(MM.forced)
		MM.push_music(url, start, volume)
	else
		MM.update_music()

/area
	// One media source per area.
	var/obj/machinery/media/media_source = null

#ifdef DEBUG_MEDIAPLAYER
to_chat(#define MP_DEBUG(x) owner, x)
#warning Please comment out #define DEBUG_MEDIAPLAYER before committing.
#else
#define MP_DEBUG(x)
#endif

/datum/component/media_manager
	var/mob/mob
	var/url = ""
	var/start_time = 0
	var/source_volume = 1 // volume * source_volume

	var/volume = 50

	var/forced=0

	var/const/window = "rpane.hosttracker"
	//var/const/window = "mediaplayer" // For debugging.
	var/playerstyle

/datum/component/media_manager/Initialize()
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	mob = parent
	var/client/_client = mob.client
	REGISTER_GLOBAL_SIGNAL(list(COMSIG_GLOB_STOP_ALL_MEDIA, COMSIG_GLOB_REBOOT), .proc/stop_music)
	RegisterSignal(mob, COMSIG_AREA_CHANGE, .proc/on_area_entered)
	open()
	update_music()
	if(_client.prefs)
		if(!isnull(_client.prefs.volume))
			volume = _client.prefs.volume
		if(_client.prefs.usewmp)
			playerstyle = PLAYER_OLD_HTML
		else
			playerstyle = PLAYER_HTML

/datum/component/media_manager/Destroy()
	mob = null
	..()

/datum/component/media_manager/proc/on_area_entered()
	RegisterSignal(mob, COMSIG_AREA_MUSIC_UPDATE, .proc/on_area_music_update)
	if(!forced)
		update_music()

/datum/component/media_manager/proc/on_area_music_update()
	if(!forced)
		update_music()

// Actually pop open the player in the background.
/datum/component/media_manager/proc/open()
	mob << browse(null, "window=[window]")
	mob << browse(playerstyle, "window=[window]")
	send_update()

/datum/component/media_manager/proc/update_music()
	var/targetURL = ""
	var/targetStartTime = 0
	var/targetVolume = 0

	if (forced || !mob)
		return

	var/area/A = get_area(mob)
	if(!A)
		stop_music()
		return
	var/obj/machinery/media/M = A.media_source // TODO: turn into a list, then only play the first one that's playing.
	if(M && M.playing)
		targetURL = M.media_url
		targetStartTime = M.media_start_time
		targetVolume = M.volume
	push_music(targetURL,targetStartTime,targetVolume)

/datum/component/media_manager/proc/update_volume(var/value)
	volume = value
	send_update()

/datum/component/media_manager/proc/stop_music()
	push_music("", 0, 1)

/datum/component/media_manager/proc/push_music(var/targetURL,var/targetStartTime,var/targetVolume)
	if (url != targetURL || abs(targetStartTime - start_time) > 1 || abs(targetVolume - source_volume) > 0.1 /* 10% */)
		url = targetURL
		start_time = targetStartTime
		source_volume = Clamp(targetVolume, 0, 1)
		send_update()

// Tell the player to play something via JS.
/datum/component/media_manager/proc/send_update()
	if(!(mob.client.prefs))
		return
	if(!(mob.client.prefs.toggles & SOUND_STREAMING) && url != "")
		return // Nope.
	MP_DEBUG("<span class='good'>Sending update to VLC ([url])...</span>")
	mob << output(list2params(list(url, (world.time - start_time) / 10, volume*source_volume)), "[window]:SetMusic")

/client/verb/change_volume()
	set name = "Set Volume"
	set category = "OOC"
	set desc = "Set jukebox volume"

/client/proc/set_new_volume()
	var/datum/component/media_manager/MM = mob.GetComponent(/datum/component/media_manager)
	if(!istype(MM))
		to_chat(usr, "You have no media_manager component. This is a bug, tell an admin.")
		return
	var/oldvolume = prefs.volume
	var/value = input("Choose your Jukebox volume.", "Jukebox volume", MM.volume)
	value = round(max(0, min(100, value)))
	MM.update_volume(value)
	if(prefs && (oldvolume != value))
		prefs.volume = value
		prefs.save_preferences_sqlite(src, ckey)
