/// <reference path="./nano_state.ts" />
/// <reference path="./nano_state_manager.ts" />

class NanoStateDefaultClass extends NanoStateClass {
	constructor() {
		super()
		this.key = 'default';
		//this.parent.constructor.call(this);
		this.key = this.key.toLowerCase();
		NanoStateManager.addState(this);
	}
}

var NanoStateDefault = new NanoStateDefaultClass();
