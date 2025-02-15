﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.ui.ProgressBar

package io.decagames.rotmg.ui{
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import flash.display.Shape;
    import flash.text.TextFormat;
    import com.greensock.TweenLite;

    public class ProgressBar extends UIGridElement {

        public static const DYNAMIC_LABEL_TOKEN:String = "{X}";
        public static const MAX_VALUE_TOKEN:String = "{M}";

        private var componentWidth:int;
        private var componentHeight:int;
        private var _staticLabel:UILabel;
        private var _dynamicLabel:UILabel;
        private var _maxLabel:UILabel;
        private var _dynamicLabelString:String;
        private var _maxValue:int;
        private var _minValue:int;
        private var backgroundColor:uint;
        private var progressBarColor:uint;
        private var backgroundShape:Shape;
        private var progressShape:Shape;
        private var _value:int;
        private var _simulatedValue:int;
        private var simulationColor:uint;
        private var _shouldAnimate:Boolean;
        private var _showMaxLabel:Boolean;
        private var _simulatedValueTextFormat:TextFormat;
        private var _maxColor:uint;
        private var useMaxColor:Boolean;

        public function ProgressBar(_arg1:int, _arg2:int, _arg3:String, _arg4:String, _arg5:int, _arg6:int, _arg7:int, _arg8:uint, _arg9:uint, _arg10:uint=0){
            this.componentWidth = _arg1;
            this.componentHeight = _arg2;
            this._staticLabel = new UILabel();
            this._staticLabel.text = _arg3;
            this._dynamicLabel = new UILabel();
            this._maxLabel = new UILabel();
            this._dynamicLabelString = _arg4;
            this._maxValue = _arg6;
            this._minValue = _arg5;
            this.backgroundColor = _arg8;
            this.progressBarColor = _arg9;
            this.simulationColor = _arg10;
            addChild(this._dynamicLabel);
            addChild(this._staticLabel);
            this.backgroundShape = new Shape();
            addChild(this.backgroundShape);
            this.progressShape = new Shape();
            addChild(this.progressShape);
            this.value = _arg7;
            this._shouldAnimate = true;
        }

        public function set value(_arg1:int):void{
            this.render(this._value, this._value, false);
            this._value = _arg1;
            this._simulatedValue = _arg1;
            this.render(this._value, this._simulatedValue, this._shouldAnimate);
        }

        public function set simulatedValue(_arg1:int):void{
            this._simulatedValue = _arg1;
            this.render(this._value, this._simulatedValue, false);
        }

        override public function resize(_arg1:int, _arg2:int=-1):void{
            this.componentWidth = _arg1;
            this.render(this._value, this._simulatedValue, false);
        }

        private function render(_arg1:int, _arg2:int, _arg3:Boolean):void{
            var _local7:int;
            var _local4 = !((_arg2 == _arg1));
            this.backgroundShape.graphics.clear();
            this.backgroundShape.graphics.beginFill(this.backgroundColor, 1);
            this.backgroundShape.graphics.drawRect(0, 0, this.componentWidth, this.componentHeight);
            var _local5:Number = ((this.componentWidth * _arg1) / (this._maxValue - this._minValue));
            if (isNaN(_local5)){
                _local5 = 0;
            }
            if (_arg3){
                TweenLite.to(this.progressShape, 1, {
                    width:_local5,
                    onComplete:this.onAnimationComplete
                });
            }
            else {
                this.progressShape.graphics.clear();
                this.progressShape.graphics.beginFill(((((this.useMaxColor) && ((_arg1 >= (this._maxValue - this._minValue))))) ? this._maxColor : this.progressBarColor), 1);
                this.progressShape.graphics.drawRect(0, 0, _local5, this.componentHeight);
                this.progressShape.width = _local5;
            }
            if (_local4){
                this.progressShape.graphics.beginFill(((((this.useMaxColor) && (((this._maxValue - this._minValue) == _arg2)))) ? this._maxColor : this.simulationColor), 1);
                this.progressShape.graphics.drawRect(_local5, 0, (((this.componentWidth * _arg2) / (this._maxValue - this._minValue)) - _local5), this.componentHeight);
            }
            var _local6:String = this._dynamicLabelString.replace(DYNAMIC_LABEL_TOKEN, ((_local4) ? _arg2 : _arg1));
            this._dynamicLabel.text = _local6.replace(MAX_VALUE_TOKEN, this._maxValue);
            this._maxLabel.text = "";
            if (((_local4) && (this._simulatedValueTextFormat))){
                _local7 = this._dynamicLabel.text.indexOf(_arg2.toString());
                this._dynamicLabel.setTextFormat(this._simulatedValueTextFormat, _local7, (_local7 + _arg2.toString().length));
                if (((this._showMaxLabel) && ((this._maxValue == _arg2)))){
                    this._maxLabel.text = "MAX";
                }
            }
            this._dynamicLabel.x = ((this.componentWidth - this._dynamicLabel.width) + 2);
            this._maxLabel.x = (this._dynamicLabel.x + this._dynamicLabel.width);
            this._staticLabel.x = -2;
            this.backgroundShape.y = this._staticLabel.height;
            this.progressShape.y = this._staticLabel.height;
        }

        private function onAnimationComplete():void{
            this.render(this._value, this._value, false);
        }

        public function get staticLabel():UILabel{
            return (this._staticLabel);
        }

        public function get dynamicLabel():UILabel{
            return (this._dynamicLabel);
        }

        public function get value():int{
            return (this._value);
        }

        public function get dynamicLabelString():String{
            return (this._dynamicLabelString);
        }

        public function set dynamicLabelString(_arg1:String):void{
            this._dynamicLabelString = _arg1;
        }

        public function get maxValue():int{
            return (this._maxValue);
        }

        public function get minValue():int{
            return (this._minValue);
        }

        public function set maxValue(_arg1:int):void{
            this._maxValue = _arg1;
        }

        public function set simulatedValueTextFormat(_arg1:TextFormat):void{
            this._simulatedValueTextFormat = _arg1;
        }

        public function get showMaxLabel():Boolean{
            return (this._showMaxLabel);
        }

        public function set showMaxLabel(_arg1:Boolean):void{
            if (((_arg1) && (!(this._maxLabel.parent)))){
                addChild(this._maxLabel);
            }
            if (((!(_arg1)) && (this._maxLabel.parent))){
                removeChild(this._maxLabel);
            }
            this._showMaxLabel = _arg1;
        }

        public function get maxLabel():UILabel{
            return (this._maxLabel);
        }

        public function get maxColor():uint{
            return (this._maxColor);
        }

        public function set maxColor(_arg1:uint):void{
            this.useMaxColor = true;
            this._maxColor = _arg1;
            this.render(this._value, this._simulatedValue, false);
        }

        public function get shouldAnimate():Boolean{
            return (this._shouldAnimate);
        }

        public function set shouldAnimate(_arg1:Boolean):void{
            this._shouldAnimate = _arg1;
        }


    }
}//package io.decagames.rotmg.ui

