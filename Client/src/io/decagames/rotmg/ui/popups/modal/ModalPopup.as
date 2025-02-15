﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.ui.popups.modal.ModalPopup

package io.decagames.rotmg.ui.popups.modal{
    import io.decagames.rotmg.ui.popups.BasePopup;
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.popups.header.PopupHeader;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import io.decagames.rotmg.ui.texture.TextureParser;

    public class ModalPopup extends BasePopup {

        protected var _contentContainer:Sprite;
        protected var contentMask:Sprite;
        protected var background:SliceScalingBitmap;
        protected var contentMargin:int = 11;
        protected var maxHeight:int = 520;
        protected var _header:PopupHeader;
        protected var _autoSize:Boolean;
        protected var scroll:UIScrollbar;
        private var buttonsList:Vector.<BaseButton>;

        public function ModalPopup(_arg1:int, _arg2:int, _arg3:String="", _arg4:Function=null, _arg5:Rectangle=null, _arg6:Number=0.8){
            var _local7:int;
            super((_arg1 + (2 * this.contentMargin)), (((_arg2 <= (2 * this.contentMargin))) ? ((2 * this.contentMargin) + 1) : (_arg2 + (2 * this.contentMargin))), _arg5);
            this._contentWidth = _arg1;
            this._contentHeight = _arg2;
            this.buttonsList = new Vector.<BaseButton>();
            this._autoSize = (_arg2 == 0);
            _popupFadeColor = 0;
            _popupFadeAlpha = _arg6;
            _showOnFullScreen = true;
            this.setBackground("popup_background_simple");
            this._contentContainer = new Sprite();
            this._contentContainer.x = this.contentMargin;
            this._contentContainer.y = this.contentMargin;
            this.contentMask = new Sprite();
            this.drawContentMask(_arg2);
            this._contentContainer.mask = this.contentMask;
            this.contentMask.x = this._contentContainer.x;
            this.contentMask.y = this._contentContainer.y;
            super.addChild(this.contentMask);
            super.addChild(this._contentContainer);
            if (_arg3 != ""){
                this._header = new PopupHeader(width, PopupHeader.TYPE_MODAL);
                this._header.setTitle(_arg3, (popupWidth - 18), (((_arg4 == null)) ? DefaultLabelFormat.defaultModalTitle : _arg4));
                super.addChild(this._header);
                _local7 = ((this._header.height / 2) - 1);
                this._contentContainer.y = (this._contentContainer.y + (_local7 + 15));
                this.contentMask.y = (this.contentMask.y + (_local7 + 15));
                this.background.y = (this.background.y + _local7);
                this.background.height = (this.background.height + 15);
            }
        }

        private function drawContentMask(_arg1:int):void{
            this.contentMask.graphics.clear();
            this.contentMask.graphics.beginFill(0xFF0000, 0.2);
            this.contentMask.graphics.drawRect(0, 0, _contentWidth, _arg1);
            this.contentMask.graphics.endFill();
        }

        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            return (this._contentContainer.addChildAt(_arg1, _arg2));
        }

        override public function addChild(_arg1:DisplayObject):DisplayObject{
            return (this._contentContainer.addChild(_arg1));
        }

        override public function removeChild(_arg1:DisplayObject):DisplayObject{
            return (this._contentContainer.removeChild(_arg1));
        }

        override public function removeChildAt(_arg1:int):DisplayObject{
            return (this._contentContainer.removeChildAt(_arg1));
        }

        override public function get height():Number{
            if (this._contentContainer.height > this.maxHeight){
                return (((this.maxHeight + (2 * this.contentMargin)) + ((this.header) ? ((this._header.height / 2) + 14) : 0)));
            }
            return (super.height);
        }

        public function resize():void{
            var _local1:int = this._contentContainer.height;
            if (_local1 > this.maxHeight){
                _local1 = this.maxHeight;
            }
            this.drawContentMask(_local1);
            this.background.height = ((_local1 + (2 * this.contentMargin)) + ((this.header) ? 15 : 0));
            if ((((this._contentContainer.height > this.maxHeight)) && (!(this.scroll)))){
                this.scroll = new UIScrollbar(_local1);
                this.scroll.x = (popupWidth - 18);
                this.scroll.y = this._contentContainer.y;
                super.addChild(this.scroll);
                this.scroll.scrollObject = this;
                this.scroll.content = this._contentContainer;
            }
        }

        public function get header():PopupHeader{
            return (this._header);
        }

        private function setBackground(_arg1:String):void{
            this.background = TextureParser.instance.getSliceScalingBitmap("UI", _arg1);
            this.background.width = popupWidth;
            this.background.height = popupHeight;
            super.addChildAt(this.background, 0);
        }

        public function dispose():void{
            var _local1:BaseButton;
            if (this.background){
                this.background.dispose();
                this.background = null;
            }
            if (this._header){
                this._header.dispose();
            }
            for each (_local1 in this.buttonsList) {
                _local1.dispose();
            }
            this.buttonsList = null;
        }

        protected function registerButton(_arg1:BaseButton):void{
            this.buttonsList.push(_arg1);
        }

        public function get contentContainer():Sprite{
            return (this._contentContainer);
        }

        public function get autoSize():Boolean{
            return (this._autoSize);
        }


    }
}//package io.decagames.rotmg.ui.popups.modal

