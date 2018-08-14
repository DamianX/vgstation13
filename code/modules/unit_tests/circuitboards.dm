/datum/unit_test/circuitboards/start()
	var/list/board_by_description = list()

	for(var/cb_type in subtypesof(/obj/item/weapon/circuitboard))
		var/obj/item/weapon/circuitboard/instance = new cb_type

		var/description = instance.desc
		if(!description)
			fail("[cb_type] has a null or emtpy description")
		else if(!board_by_description[description])
			board_by_description[description] = list(cb_type)
		else
			board_by_description[description] += list(cb_type)

		var/req_components = instance.req_components
		for(var/component in req_components)
			if(!ispath(component))
				if(istext(component))
					fail("[cb_type] specified [component] as a text string")
				else
					fail("[cb_type] specified an invalid [component]")
			var/component_amount = req_components[component]
			if(!isnum(component_amount))
				fail("[cb_type] specified an invalid amount for the [component] component: [component_amount]")
			
		var/build_path = instance.build_path
		var/list/abstract_types = list(
			/obj/item/weapon/circuitboard/sorting_machine,
			/obj/item/weapon/circuitboard/telecomms,
		)
		if(cb_type in abstract_types)
			continue
		if(instance.board_type == OTHER)
			continue
		
		if(!ispath(build_path))
			if(istext(build_path))
				fail("[cb_type] specified build_path as a text string")
			else
				fail("[cb_type] specified an invalid build_path")

	for(var/description in board_by_description)
		var/list/boards_with_this_description = board_by_description[description]
		if(boards_with_this_description.len > 1)
			fail("The following paths all share the same description: [english_list(boards_with_this_description)]")
				
