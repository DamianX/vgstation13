var/datum/subsystem/http/SShttp

/datum/subsystem/http
	name          = "HTTP"
	init_order    = SS_INIT_HTTP
	display_order = SS_DISPLAY_HTTP
	priority      = SS_PRIORITY_HTTP
	wait          = 1
	flags         = SS_TICKER | SS_BACKGROUND

	var/list/datum/http_request/active_requests
	var/logging_enabled = FALSE
	/// Total requests processed in a round
	var/requests_processed

/datum/subsystem/http/New()
	NEW_SS_GLOBAL(SShttp)

/datum/subsystem/http/Initialize()
	active_requests = list()
	rustg_create_http_client()
	..()

/datum/subsystem/http/stat_entry()
	..("P: [length(active_requests)] | T: [requests_processed]")

/datum/subsystem/http/fire(resumed = FALSE)
	for(var/r in active_requests)
		var/datum/http_request/req = r
		if(!req.is_complete())
			continue
		active_requests -= req
		var/datum/http_response/res = req.into_response()

		if(req.callback)
			req.callback.invoke_async(res)

		if(logging_enabled)
			var/list/log_data = list("BEGIN ASYNC RESPONSE (ID: [req.id])")
			if(res.errored)
				log_data += "\t ----- RESPONSE ERROR -----"
				log_data += "\t [res.error]"
			else
				log_data += "\tResponse status code: [res.status_code]"
				log_data += "\tResponse body: [res.body]"
				log_data += "\tResponse headers: [json_encode(res.headers)]"
			log_data += "END ASYNC RESPONSE (ID: [req.id])"
			log_http(log_data.Join("\n"))

/datum/subsystem/http/proc/create_request(method, url, body = "", list/headers, callback/proc_callback)
	var/datum/http_request/req = new
	req.prepare(method, url, body, headers)
	req.callback = proc_callback

	req.begin()
	active_requests += req
	requests_processed++

	if(logging_enabled)
		var/list/log_data = list()
		log_data += "BEGIN ASYNC REQUEST (ID: [req.id])"
		log_data += "\t[uppertext(req.method)] [req.url]"
		log_data += "\tRequest body: [req.body]"
		log_data += "\tRequest headers: [req.headers]"
		log_data += "END ASYNC REQUEST (ID: [req.id])"

		log_http(log_data.Join("\n"))
