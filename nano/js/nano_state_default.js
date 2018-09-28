/// <reference path="./nano_state.ts" />
/// <reference path="./nano_state_manager.ts" />
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    }
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var NanoStateDefaultClass = /** @class */ (function (_super) {
    __extends(NanoStateDefaultClass, _super);
    function NanoStateDefaultClass() {
        var _this = _super.call(this) || this;
        _this.key = 'default';
        //this.parent.constructor.call(this);
        _this.key = _this.key.toLowerCase();
        NanoStateManager.addState(_this);
        return _this;
    }
    return NanoStateDefaultClass;
}(NanoStateClass));
var NanoStateDefault = new NanoStateDefaultClass();
