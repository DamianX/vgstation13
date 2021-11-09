
/datum/event/mundane_news
	endWhen = 10

/datum/event/mundane_news/announce()
	var/datum/trade_destination/affected_dest = pickweight(weighted_mundaneevent_locations)
	var/event_type = 0
	if(affected_dest.viable_mundane_events.len)
		event_type = pick(affected_dest.viable_mundane_events)

	if(!event_type)
		return

	//copy-pasted from the admin verbs to submit new newscaster messages
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = "Tau Ceti Daily"
	newMsg.is_admin_message = 1

	//see if our location has custom event info for this event
	newMsg.body = affected_dest.get_custom_eventstring()
	if(!newMsg.body)
		newMsg.body = "[affected_dest.name] doesn't have custom events.  Bug a coder."

	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(FC.channel_name == "Tau Ceti Daily")
			FC.messages += newMsg
			break
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert("Tau Ceti Daily")

/datum/event/trivial_news
	endWhen = 10

/datum/event/trivial_news/announce()
	//copy-pasted from the admin verbs to submit new newscaster messages
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = "Editor Mike Hammers"
	//newMsg.is_admin_message = 1
	var/datum/trade_destination/affected_dest = pick(weighted_mundaneevent_locations)
	newMsg.body = pick(file2list("config/news/trivial.txt"))
	newMsg.body = replacetext(newMsg.body,"{{AFFECTED}}",affected_dest.name)

	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(FC.channel_name == "The Gibson Gazette")
			FC.messages += newMsg
			break
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert("The Gibson Gazette")
