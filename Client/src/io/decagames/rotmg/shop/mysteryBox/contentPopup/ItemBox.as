﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.shop.mysteryBox.contentPopup.ItemBox

package io.decagames.rotmg.shop.mysteryBox.contentPopup{
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.labels.UILabel;
    import flash.display.Bitmap;
    import flash.text.TextFieldAutoSize;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.display.BitmapData;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;

    public class ItemBox extends UIGridElement {

        private var _itemId:String;
        private var bitmapName:String;
        private var isLastElement:Boolean;
        private var amount:int;
        private var _itemBackground:Sprite;
        private var showFullName:Boolean;
        private var isBackgroundCleared:Boolean;
        private var label:UILabel;
        private var targetWidth:int = 260;
        private var itemSize:int = 40;
        private var itemMargin:int = 2;
        private var imageBitmap:Bitmap;

        public function ItemBox(_arg1:String, _arg2:int, _arg3:Boolean, _arg4:String="", _arg5:Boolean=false){
            this._itemId = _arg1;
            this.bitmapName = _arg4;
            this.isLastElement = _arg5;
            this.amount = _arg2;
            this.showFullName = _arg3;
            this.label = new UILabel();
            this.label.multiline = true;
            this.label.autoSize = TextFieldAutoSize.LEFT;
            this.label.wordWrap = true;
            DefaultLabelFormat.mysteryBoxContentItemName(this.label);
            this.drawBackground(_arg4, _arg5, 260);
            this.drawElement(_arg1, _arg2);
            this.resizeLabel();
        }

        private function drawBackground(_arg1:String, _arg2:Boolean, _arg3:int):void{
            if (_arg1 == ""){
                this.graphics.clear();
                this.graphics.beginFill(0x2D2D2D);
                this.graphics.drawRect(0, 0, _arg3, (this.itemSize + (2 * this.itemMargin)));
                this.graphics.endFill();
            }
        }

        public function clearBackground():void{
            this.isBackgroundCleared = true;
            this.graphics.clear();
        }

        private function drawElement(_arg1:String, _arg2:int):void{
            this._itemBackground = new Sprite();
            this._itemBackground.graphics.clear();
            this._itemBackground.graphics.beginFill(0xFFFFFF, 0);
            this._itemBackground.graphics.drawRect(0, 0, this.itemSize, this.itemSize);
            this._itemBackground.graphics.endFill();
            addChild(this._itemBackground);
            this._itemBackground.x = 10;
            this._itemBackground.y = 4;
            var _local3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(int(_arg1), (this._itemBackground.width * 2), true, false);
            this.imageBitmap = new Bitmap(_local3);
            this.imageBitmap.x = -(Math.round(((this.imageBitmap.width - this.itemSize) / 2)));
            this.imageBitmap.y = -(Math.round(((this.imageBitmap.height - this.itemSize) / 2)));
            this._itemBackground.addChild(this.imageBitmap);
            if (this.showFullName){
                this.label.text = ((_arg2 + "x ") + LineBuilder.getLocalizedStringFromKey(ObjectLibrary.typeToDisplayId_[_arg1]));
                this.label.x = 55;
            }
            else {
                this.label.text = (_arg2 + "x");
                this.label.x = 10;
                this._itemBackground.x = (this._itemBackground.x + (this.label.x + 10));
            }
            addChild(this.label);
        }

        override public function get height():Number{
            return ((this.itemSize + (2 * this.itemMargin)));
        }

        private function resizeLabel():void{
            this.label.width = ((this.targetWidth - (this.itemSize + (2 * this.itemMargin))) - 16);
            this.label.y = (((this.height - this.label.textHeight) - 4) / 2);
        }

        override public function resize(_arg1:int, _arg2:int=-1):void{
            if (!this.isBackgroundCleared){
                this.drawBackground(this.bitmapName, this.isLastElement, _arg1);
            }
            this.targetWidth = _arg1;
            this.resizeLabel();
        }

        override public function dispose():void{
            if (this.imageBitmap){
                this.imageBitmap.bitmapData.dispose();
            }
            super.dispose();
        }

        public function get itemId():String{
            return (this._itemId);
        }

        public function get itemBackground():Sprite{
            return (this._itemBackground);
        }


    }
}//package io.decagames.rotmg.shop.mysteryBox.contentPopup

