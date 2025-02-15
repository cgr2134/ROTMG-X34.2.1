﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.dailyQuests.view.list.DailyQuestListElement

package io.decagames.rotmg.dailyQuests.view.list{
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import flash.display.Bitmap;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import flash.filters.DropShadowFilter;
    import flash.filters.BitmapFilterQuality;

    public class DailyQuestListElement extends Sprite {

        private var _id:String;
        private var _questName:String;
        private var _completed:Boolean;
        private var selectedBorder:Sprite;
        private var _isSelected:Boolean;
        private var ready:Boolean;
        private var background:SliceScalingBitmap;
        private var icon:Bitmap;
        private var questNameTextfield:UILabel;
        private var _category:int;

        public function DailyQuestListElement(_arg1:String, _arg2:String, _arg3:Boolean, _arg4:Boolean, _arg5:int){
            this._id = _arg1;
            this._questName = _arg2;
            this._completed = _arg3;
            this.ready = _arg4;
            this._category = _arg5;
            this.setElements();
        }

        public function dispose():void{
            this.background.dispose();
            this.icon = null;
            this.selectedBorder.removeChildren();
        }

        private function setElements():void{
            this.selectedBorder = new Sprite();
            this.background = TextureParser.instance.getSliceScalingBitmap("UI", "daily_quest_list_element_grey", 190);
            this.icon = TextureParser.instance.getTexture("UI", "daily_quest_list_element_available_icon");
            this.background.height = 30;
            this.icon.x = 5;
            this.icon.y = 5;
            this.questNameTextfield = new UILabel();
            DefaultLabelFormat.questNameListLabel(this.questNameTextfield, (((this._category == 7)) ? 2201331 : ((((this._completed) || (this._isSelected))) ? 0xFFFFFF : 0xCFCFCF)));
            this.questNameTextfield.filters = [new DropShadowFilter(1, 90, 0, 1, 2, 2), new DropShadowFilter(0, 90, 0, 0.4, 4, 4, 1, BitmapFilterQuality.HIGH)];
            this.questNameTextfield.text = this._questName;
            this.questNameTextfield.x = 24;
            this.questNameTextfield.y = 7;
            addChild(this.background);
            addChild(this.icon);
            addChild(this.questNameTextfield);
            this.draw();
        }

        private function draw():void{
            removeChild(this.icon);
            removeChild(this.background);
            if (this._completed){
                this.icon = TextureParser.instance.getTexture("UI", "daily_quest_list_element_complete_icon");
            }
            else {
                if (this.ready){
                    this.icon = TextureParser.instance.getTexture("UI", "daily_quest_list_element_ready_icon");
                }
                else {
                    this.icon = TextureParser.instance.getTexture("UI", "daily_quest_list_element_available_icon");
                }
            }
            this.icon.x = 5;
            this.icon.y = 5;
            if (this._isSelected){
                this.background = TextureParser.instance.getSliceScalingBitmap("UI", "daily_quest_list_element_orange", 190);
            }
            else {
                if (this._completed){
                    this.background = TextureParser.instance.getSliceScalingBitmap("UI", "daily_quest_list_element_green", 190);
                }
                else {
                    this.background = TextureParser.instance.getSliceScalingBitmap("UI", "daily_quest_list_element_grey", 190);
                }
            }
            DefaultLabelFormat.questNameListLabel(this.questNameTextfield, (((this._category == 7)) ? 2201331 : ((((this._completed) || (this._isSelected))) ? 0xFFFFFF : 0xCFCFCF)));
            this.questNameTextfield.alpha = ((((this._completed) || (this._isSelected))) ? 1 : 0.5);
            this.background.height = 30;
            addChild(this.background);
            addChild(this.icon);
            addChild(this.questNameTextfield);
        }

        public function get id():String{
            return (this._id);
        }

        public function get category():int{
            return (this._category);
        }

        public function set isSelected(_arg1:Boolean):void{
            this._isSelected = _arg1;
            this.draw();
        }

        public function get isSelected():Boolean{
            return (this._isSelected);
        }


    }
}//package io.decagames.rotmg.dailyQuests.view.list

