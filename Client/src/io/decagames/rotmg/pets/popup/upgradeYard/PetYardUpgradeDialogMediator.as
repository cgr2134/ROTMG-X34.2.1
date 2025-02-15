﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.pets.popup.upgradeYard.PetYardUpgradeDialogMediator

package io.decagames.rotmg.pets.popup.upgradeYard{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.core.model.PlayerModel;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.signals.UpgradePetSignal;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.ui.popups.header.PopupHeader;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import com.company.assembleegameclient.util.Currency;
    import io.decagames.rotmg.shop.NotEnoughResources;
    import io.decagames.rotmg.pets.data.vo.requests.UpgradePetYardRequestVO;
    import com.company.assembleegameclient.objects.Player;

    public class PetYardUpgradeDialogMediator extends Mediator {

        [Inject]
        public var view:PetYardUpgradeDialog;
        [Inject]
        public var closePopupSignal:ClosePopupSignal;
        private var closeButton:SliceScalingButton;
        [Inject]
        public var gameModel:GameModel;
        [Inject]
        public var playerModel:PlayerModel;
        [Inject]
        public var showDialog:ShowPopupSignal;
        [Inject]
        public var model:PetsModel;
        [Inject]
        public var upgradePet:UpgradePetSignal;


        override public function initialize():void{
            this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
            this.closeButton.clickSignal.addOnce(this.onClose);
            this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
            this.view.upgradeFameButton.clickSignal.add(this.onFamePurchase);
            this.view.upgradeGoldButton.clickSignal.add(this.onGoldPurchase);
        }

        override public function destroy():void{
            this.closeButton.clickSignal.remove(this.onClose);
            this.closeButton.dispose();
            this.view.upgradeFameButton.clickSignal.remove(this.onFamePurchase);
            this.view.upgradeGoldButton.clickSignal.remove(this.onGoldPurchase);
        }

        private function onClose(_arg1:BaseButton):void{
            this.closePopupSignal.dispatch(this.view);
        }

        private function onFamePurchase(_arg1:BaseButton):void{
            this.purchase(Currency.FAME, this.model.getPetYardUpgradeFamePrice());
        }

        private function onGoldPurchase(_arg1:BaseButton):void{
            this.purchase(Currency.GOLD, this.model.getPetYardUpgradeGoldPrice());
        }

        private function purchase(_arg1:int, _arg2:int):void{
            if ((((_arg1 == Currency.GOLD)) && ((this.currentGold < _arg2)))){
                this.showDialog.dispatch(new NotEnoughResources(300, Currency.GOLD));
                return;
            }
            if ((((_arg1 == Currency.FAME)) && ((this.currentFame < _arg2)))){
                this.showDialog.dispatch(new NotEnoughResources(300, Currency.FAME));
                return;
            }
            var _local3:int = this.model.getPetYardObjectID();
            var _local4:UpgradePetYardRequestVO = new UpgradePetYardRequestVO(_local3, _arg1);
            this.closePopupSignal.dispatch(this.view);
            this.upgradePet.dispatch(_local4);
        }

        private function get currentGold():int{
            var _local1:Player = this.gameModel.player;
            if (_local1 != null){
                return (_local1.credits_);
            }
            if (this.playerModel != null){
                return (this.playerModel.getCredits());
            }
            return (0);
        }

        private function get currentFame():int{
            var _local1:Player = this.gameModel.player;
            if (_local1 != null){
                return (_local1.fame_);
            }
            if (this.playerModel != null){
                return (this.playerModel.getFame());
            }
            return (0);
        }


    }
}//package io.decagames.rotmg.pets.popup.upgradeYard

