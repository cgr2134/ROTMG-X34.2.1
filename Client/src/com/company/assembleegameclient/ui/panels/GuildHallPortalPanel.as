﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.panels.GuildHallPortalPanel

package com.company.assembleegameclient.ui.panels{
    import kabam.rotmg.ui.view.SignalWaiter;
    import com.company.assembleegameclient.util.StageProxy;
    import com.company.assembleegameclient.objects.GuildHallPortal;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import com.company.assembleegameclient.ui.DeprecatedTextButton;
    import com.company.assembleegameclient.objects.Player;
    import flash.text.TextFieldAutoSize;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.model.TextKey;
    import flash.filters.DropShadowFilter;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.company.assembleegameclient.game.AGameSprite;
    import flash.events.KeyboardEvent;
    import com.company.assembleegameclient.parameters.Parameters;

    public class GuildHallPortalPanel extends Panel {

        private const waiter:SignalWaiter = new SignalWaiter();

        public var stageProxy:StageProxy;
        private var owner_:GuildHallPortal;
        private var nameText_:TextFieldDisplayConcrete;
        private var enterButton_:DeprecatedTextButton;
        private var noGuildText_:TextFieldDisplayConcrete;

        public function GuildHallPortalPanel(_arg1:AGameSprite, _arg2:GuildHallPortal){
            var _local3:Player;
            super(_arg1);
            this.stageProxy = new StageProxy(this);
            this.owner_ = _arg2;
            if ((((gs_.map == null)) || ((gs_.map.player_ == null)))){
                return;
            }
            _local3 = gs_.map.player_;
            this.nameText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF).setTextWidth(WIDTH).setWordWrap(true).setMultiLine(true).setAutoSize(TextFieldAutoSize.CENTER).setBold(true).setHTML(true);
            this.nameText_.setStringBuilder(new LineBuilder().setParams(TextKey.GUILD_HALL_PORTAL_TITLE).setPrefix('<p align="center">').setPostfix("</p>"));
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.nameText_.y = 6;
            addChild(this.nameText_);
            if (((!((_local3.guildName_ == null))) && ((_local3.guildName_.length > 0)))){
                this.enterButton_ = new DeprecatedTextButton(16, TextKey.PANEL_ENTER);
                this.enterButton_.addEventListener(MouseEvent.CLICK, this.onEnterSpriteClick);
                addChild(this.enterButton_);
                this.waiter.push(this.enterButton_.textChanged);
                addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            }
            else {
                this.noGuildText_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFF0000).setTextWidth(WIDTH).setAutoSize(TextFieldAutoSize.CENTER).setHTML(true).setBold(true);
                this.noGuildText_.setStringBuilder(new LineBuilder().setParams(TextKey.GUILD_HALL_PORTAL_NO_GUILD).setPrefix('<p align="center">').setPostfix("</p>"));
                this.noGuildText_.filters = [new DropShadowFilter(0, 0, 0)];
                this.waiter.push(this.noGuildText_.textChanged);
                addChild(this.noGuildText_);
            }
            this.waiter.complete.addOnce(this.alignUI);
        }

        private function alignUI():void{
            if (this.noGuildText_){
                this.noGuildText_.y = ((HEIGHT - this.noGuildText_.height) - 12);
            }
            if (this.enterButton_){
                this.enterButton_.x = ((WIDTH / 2) - (this.enterButton_.width / 2));
                this.enterButton_.y = ((HEIGHT - this.enterButton_.height) - 4);
            }
        }

        private function onAdded(_arg1:Event):void{
            this.stageProxy.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
        }

        private function onRemoved(_arg1:Event):void{
            this.stageProxy.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        }

        private function onEnterSpriteClick(_arg1:MouseEvent):void{
            this.enterPortal();
        }

        private function onKeyDown(_arg1:KeyboardEvent):void{
            if ((((_arg1.keyCode == Parameters.data_.interact)) && ((stage.focus == null)))){
                this.enterPortal();
            }
        }

        private function enterPortal():void{
            gs_.gsc_.usePortal(this.owner_.objectId_);
        }


    }
}//package com.company.assembleegameclient.ui.panels

