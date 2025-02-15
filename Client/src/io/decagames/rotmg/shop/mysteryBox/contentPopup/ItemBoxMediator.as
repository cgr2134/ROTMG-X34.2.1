﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.shop.mysteryBox.contentPopup.ItemBoxMediator

package io.decagames.rotmg.shop.mysteryBox.contentPopup{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.constants.InventoryOwnerTypes;
    import flash.events.MouseEvent;

    public class ItemBoxMediator extends Mediator {

        [Inject]
        public var view:ItemBox;
        [Inject]
        public var hud:HUDModel;
        [Inject]
        public var showTooltipSignal:ShowTooltipSignal;
        private var tooltip:EquipmentToolTip;


        override public function initialize():void{
            var _local1:Player = ((((this.hud.gameSprite) && (this.hud.gameSprite.map))) ? this.hud.gameSprite.map.player_ : null);
            var _local2:int = ObjectLibrary.idToType_[int(this.view.itemId)];
            this.tooltip = new EquipmentToolTip(int(this.view.itemId), _local1, _local2, InventoryOwnerTypes.CURRENT_PLAYER);
            this.view.itemBackground.addEventListener(MouseEvent.ROLL_OVER, this.onRollOverHandler);
        }

        private function onRollOverHandler(_arg1:MouseEvent):void{
            this.tooltip.attachToTarget(this.view);
            this.showTooltipSignal.dispatch(this.tooltip);
        }

        override public function destroy():void{
            this.view.itemBackground.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOverHandler);
            this.tooltip.detachFromTarget();
        }


    }
}//package io.decagames.rotmg.shop.mysteryBox.contentPopup

