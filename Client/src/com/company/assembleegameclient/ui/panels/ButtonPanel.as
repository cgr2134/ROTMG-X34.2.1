﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.panels.ButtonPanel

package com.company.assembleegameclient.ui.panels{
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import com.company.assembleegameclient.ui.DeprecatedTextButton;
    import flash.text.TextFieldAutoSize;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import flash.filters.DropShadowFilter;
    import flash.events.MouseEvent;
    import com.company.assembleegameclient.game.GameSprite;

    public class ButtonPanel extends Panel {

        private var titleText_:TextFieldDisplayConcrete;
        protected var button_:DeprecatedTextButton;

        public function ButtonPanel(_arg1:GameSprite, _arg2:String, _arg3:String){
            super(_arg1);
            this.titleText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF).setTextWidth(WIDTH).setHTML(true).setWordWrap(true).setMultiLine(true).setAutoSize(TextFieldAutoSize.CENTER);
            this.titleText_.setBold(true);
            this.titleText_.setStringBuilder(new LineBuilder().setParams(_arg2).setPrefix('<p align="center">').setPostfix("</p>"));
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.titleText_.y = 6;
            addChild(this.titleText_);
            this.button_ = new DeprecatedTextButton(16, _arg3);
            this.button_.addEventListener(MouseEvent.CLICK, this.onButtonClick);
            this.button_.textChanged.addOnce(this.alignButton);
            addChild(this.button_);
        }

        private function alignButton():void{
            this.button_.x = int(((WIDTH / 2) - (this.button_.width / 2)));
            this.button_.y = ((HEIGHT - this.button_.height) - 4);
        }

        protected function onButtonClick(_arg1:MouseEvent):void{
        }


    }
}//package com.company.assembleegameclient.ui.panels

