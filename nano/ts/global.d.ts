import * as $ from 'jquery';

declare global {
	interface JQuery {
		drags: any;
		oneTime: (interval: any, label: any, fn: any) => JQuery;
		stopTime: (label?: any, fn?: any) => JQuery;
	}
	interface JQueryStatic {
		templates: any;
	}
	interface Function {
		inheritsFrom: any;
	}
	interface String {
		toTitleCase: any;
		ckey: any;
		format: (...things) => any;
		format_regex: RegExp;
	}
	interface Window {
		console: any;
	}
	interface ObjectConstructor {
		size: any
	}
}

export {};
