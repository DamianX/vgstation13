/datum/migration/sqlite/ss13_prefs/_014
	id = 14
	name = "Add Positronic Brain Preference"

/datum/migration/sqlite/ss13_prefs/_014/up()
	if(!hasColumn("limbs","brain"))
		return execute("ALTER TABLE `limbs` ADD COLUMN brain INTEGER DEFAULT 1")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_014/down()
	if(hasColumn("limbs","brain"))
		return execute("ALTER TABLE `limbs` DROP COLUMN brain")
	return TRUE
