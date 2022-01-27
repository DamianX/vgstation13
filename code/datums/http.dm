/datum/http_request
	var/id
	var/in_progress = FALSE
	var/method
	var/body
	var/headers
	var/url
	/// If present, response body will be contained in this file.
	var/output_file
	/// To be decoded into a [/datum/http_response].
	var/_raw_response
	/// Optional. Will be invoked with one argument of type [/datum/http_response] after completion, even if it errored.
	var/callback/callback

/*
##################################################################
!!! THE METHODS IN THIS FILE ARE TO BE USED BY THE SUBSYSTEM !!!
!!! DO NOT MANUALLY INVOKE THEM !!!
##################################################################
*/

/datum/http_request/proc/prepare(_method, _url, _body = "", list/_headers, _output_file)
	if(!length(_headers))
		headers = ""
	else
		headers = json_encode(_headers)

	method = _method
	url = _url
	body = _body
	output_file = _output_file

/datum/http_request/proc/begin()
	if(in_progress)
		CRASH("Attempted to re-use a request object.")

	var/options
	if(output_file)
		options = json_encode(list(
			"output_filename" = output_file,
			"body_filename" = null
		))

	id = rustg_http_request_async(method, url, body, headers, options)

	if(isnull(text2num(id)))
		_raw_response = "Proc error: [id]"
		CRASH("Proc error: [id]")
	else
		in_progress = TRUE

/datum/http_request/proc/build_options()
	if(!output_file)
		return null
	return json_encode(list(
		"output_filename" = output_file,
		"body_filename" = null))

/datum/http_request/proc/is_complete()
	if(isnull(id))
		CRASH("Request with no ID")

	if(!in_progress)
		return TRUE

	var/result = rustg_http_check_request(id)
	if(result == RUSTG_JOB_NO_RESULTS_YET)
		return FALSE

	_raw_response = result
	in_progress = FALSE
	return TRUE

/datum/http_request/proc/into_response()
	var/datum/http_response/res = new
	try
		var/list/L = json_decode(_raw_response)
		res.status_code = L["status_code"]
		res.headers = L["headers"]
		res.body = L["body"]
	catch
		res.errored = TRUE
		res.error = _raw_response

	return res

/datum/http_response
	var/status_code
	var/body
	var/list/headers
	var/errored = FALSE
	var/error
