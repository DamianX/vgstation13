var/datum/subsystem/metrics/SSmetrics

/datum/subsystem/metrics
	name          = "Metrics"
	init_order    = SS_INIT_METRICS
	display_order = SS_DISPLAY_METRICS
	priority      = SS_PRIORITY_METRICS
	wait          = 30 SECONDS
	flags         = SS_KEEP_TIMING

/datum/subsystem/metrics/New()
	NEW_SS_GLOBAL(SSmetrics)

/datum/subsystem/metrics/Initialize()
	if(!config.enable_metrics)
		flags |= SS_NO_FIRE
	..()

/datum/subsystem/metrics/fire(resumed = FALSE)
	SShttp.create_request(RUSTG_HTTP_METHOD_POST, config.metrics_endpoint, metrics_json(), list(
		"Authorization" = "ApiKey [config.metrics_api_token]",
		"Content-Type" = "application/json"
	))

/datum/subsystem/metrics/proc/metrics_json()
	var/list/ss_data = list()
	for(var/datum/subsystem/ss in Master.subsystems)
		ss_data[ss.metrics_id] = ss.metrics()

	return json_encode(list(
		"@timestamp" = time_stamp(),
		"cpu" = world.cpu,
		"maptick" = world.map_cpu,
		"elapsed_processed" = world.time,
		"elapsed_real" = (REALTIMEOFDAY - world_startup_time),
		"client_count" = length(global.clients),
		"subsystems" = ss_data
	))
