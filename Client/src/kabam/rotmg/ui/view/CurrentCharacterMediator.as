﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.ui.view.CurrentCharacterMediator

package kabam.rotmg.ui.view{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.classes.model.ClassesModel;
    import kabam.rotmg.core.signals.TrackEventSignal;
    import kabam.rotmg.core.signals.SetScreenSignal;
    import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
    import kabam.rotmg.game.signals.PlayGameSignal;
    import kabam.rotmg.ui.signals.NameChangedSignal;
    import kabam.rotmg.core.signals.TrackPageViewSignal;
    import kabam.rotmg.packages.control.InitPackagesSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
    import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
    import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
    import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
    import io.decagames.rotmg.seasonalEvent.signals.ShowSeasonComingPopupSignal;
    import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventErrorPopup;
    import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsInfoDialog;
    import kabam.rotmg.dialogs.model.PopupNamesConfig;
    import com.company.assembleegameclient.parameters.Parameters;
    import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventComingPopup;
    import com.company.assembleegameclient.screens.ServersScreen;
    import com.company.util.MoreDateUtil;
    import com.company.assembleegameclient.screens.NewCharacterScreen;
    import flash.events.MouseEvent;
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.game.model.GameInitData;

    public class CurrentCharacterMediator extends Mediator {

        private const DAY_IN_MILLISECONDS:int = 86400000;
        private const MINUTES_IN_MILLISECONDS:int = 60000;

        [Inject]
        public var view:CharacterSelectionAndNewsScreen;
        [Inject]
        public var playerModel:PlayerModel;
        [Inject]
        public var classesModel:ClassesModel;
        [Inject]
        public var setScreen:SetScreenSignal;
        [Inject]
        public var setScreenWithValidData:SetScreenWithValidDataSignal;
        [Inject]
        public var playGame:PlayGameSignal;
        [Inject]
        public var nameChanged:NameChangedSignal;
        [Inject]
        public var initPackages:InitPackagesSignal;
        [Inject]
        public var openDialog:OpenDialogSignal;
        [Inject]
        public var seasonalEventModel:SeasonalEventModel;
        [Inject]
        public var showPopupSignal:ShowPopupSignal;
        [Inject]
        public var closePopupSignal:ClosePopupSignal;
        [Inject]
        public var addToQueueSignal:AddPopupToStartupQueueSignal;
        [Inject]
        public var flushQueueSignal:FlushPopupStartupQueueSignal;
        [Inject]
        public var showSeasonComingPopupSignal:ShowSeasonComingPopupSignal;
        private var seasonalEventErrorPopUp:SeasonalEventErrorPopup;


        override public function initialize():void{
            var _local1:Number;
            var _local2:Number;
            this.view.initialize(this.playerModel);
            this.view.close.add(this.onClose);
            this.view.newCharacter.add(this.onNewCharacter);
            this.view.showClasses.add(this.onNewCharacter);
            this.view.playGame.add(this.onPlayGame);
            this.view.serversClicked.add(this.showServersScreen);
            this.nameChanged.add(this.onNameChanged);
            this.initPackages.dispatch();
            if (this.seasonalEventModel.scheduledSeasonalEvent){
                if (Parameters.data_[PopupNamesConfig.CHALLENGER_INFO_POPUP]){
                    _local1 = Parameters.data_[PopupNamesConfig.CHALLENGER_INFO_POPUP];
                    _local2 = new Date().time;
                    if ((_local2 - (_local1 + this.DAY_IN_MILLISECONDS)) > 0){
                        this.showSeasonsComingPopup();
                        Parameters.data_[PopupNamesConfig.CHALLENGER_INFO_POPUP] = _local2;
                    }
                }
                else {
                    this.showSeasonsComingPopup();
                    Parameters.data_[PopupNamesConfig.CHALLENGER_INFO_POPUP] = new Date().time;
                }
            }
        }

        override public function destroy():void{
            this.nameChanged.remove(this.onNameChanged);
            this.view.close.remove(this.onClose);
            this.view.newCharacter.remove(this.onNewCharacter);
            this.view.showClasses.remove(this.onNewCharacter);
            this.view.playGame.remove(this.onPlayGame);
        }

        private function onNameChanged(_arg1:String):void{
            this.view.setName(_arg1);
        }

        private function showSeasonsComingPopup():void{
            this.showPopupSignal.dispatch(new SeasonalEventComingPopup(this.seasonalEventModel.scheduledSeasonalEvent));
        }

        private function showServersScreen():void{
            this.setScreen.dispatch(new ServersScreen(Boolean(this.seasonalEventModel.isChallenger)));
        }

        private function onNewCharacter():void{
            if (((this.seasonalEventModel.isChallenger) && ((this.seasonalEventModel.remainingCharacters == 0)))){
                this.showSeasonalErrorPopUp("You cannot create more characters");
            }
            else {
                this.setScreen.dispatch(new NewCharacterScreen());
            };
        }

        private function showSeasonalErrorPopUp(_arg1:String):void{
            this.seasonalEventErrorPopUp = new SeasonalEventErrorPopup(_arg1);
            this.seasonalEventErrorPopUp.okButton.addEventListener(MouseEvent.CLICK, this.onSeasonalErrorPopUpClose);
            this.showPopupSignal.dispatch(this.seasonalEventErrorPopUp);
        }

        private function onSeasonalErrorPopUpClose(_arg1:MouseEvent):void{
            this.seasonalEventErrorPopUp.okButton.removeEventListener(MouseEvent.CLICK, this.onSeasonalErrorPopUpClose);
            this.closePopupSignal.dispatch(this.seasonalEventErrorPopUp);
        }

        private function onClose():void{
            this.seasonalEventModel.isChallenger = 0;
            this.playerModel.isInvalidated = true;
            this.playerModel.isLogOutLogIn = true;
            this.setScreenWithValidData.dispatch(new TitleView());
        }

        private function onPlayGame():void{
            var _local1:SavedCharacter = this.playerModel.getCharacterByIndex(0);
            this.playerModel.currentCharId = _local1.charId();
            var _local2:CharacterClass = this.classesModel.getCharacterClass(_local1.objectType());
            _local2.setIsSelected(true);
            _local2.skins.getSkin(_local1.skinType()).setIsSelected(true);
            var _local4:GameInitData = new GameInitData();
            _local4.createCharacter = false;
            _local4.charId = _local1.charId();
            _local4.isNewGame = true;
            this.playGame.dispatch(_local4);
        }


    }
}//package kabam.rotmg.ui.view

