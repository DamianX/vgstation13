/datum/migration/sqlite/ss13_prefs/_014
	id = 14
	name = "Add Ghost Sight Preference"

/datum/migration/sqlite/ss13_prefs/_014/up()
	if(!hasColumn("client","ghost_sight"))
		return execute("ALTER TABLE `client` ADD COLUMN ghost_sight INTEGER DEFAULT 0")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_014/down()
	if(hasColumn("client","ghost_sight"))
		return execute("ALTER TABLE `client` DROP COLUMN ghost_sight")
	return TRUE
