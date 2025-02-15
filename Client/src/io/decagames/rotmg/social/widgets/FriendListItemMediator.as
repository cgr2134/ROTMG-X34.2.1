﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.social.widgets.FriendListItemMediator

package io.decagames.rotmg.social.widgets{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
    import io.decagames.rotmg.social.signals.FriendActionSignal;
    import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
    import io.decagames.rotmg.social.model.SocialModel;
    import io.decagames.rotmg.social.signals.RefreshListSignal;
    import kabam.rotmg.chat.control.ShowChatInputSignal;
    import io.decagames.rotmg.ui.popups.signals.CloseCurrentPopupSignal;
    import kabam.rotmg.ui.signals.EnterGameSignal;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.signals.PlayGameSignal;
    import flash.events.MouseEvent;
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.game.model.GameInitData;
    import io.decagames.rotmg.social.model.FriendRequestVO;
    import io.decagames.rotmg.social.config.FriendsActions;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import io.decagames.rotmg.ui.popups.modal.ConfirmationModal;
    import kabam.rotmg.text.model.TextKey;

    public class FriendListItemMediator extends Mediator {

        [Inject]
        public var view:FriendListItem;
        [Inject]
        public var showPopupSignal:ShowPopupSignal;
        [Inject]
        public var showFade:ShowLockFade;
        [Inject]
        public var friendsAction:FriendActionSignal;
        [Inject]
        public var showPopup:ShowPopupSignal;
        [Inject]
        public var removeFade:RemoveLockFade;
        [Inject]
        public var model:SocialModel;
        [Inject]
        public var refreshSignal:RefreshListSignal;
        [Inject]
        public var chatSignal:ShowChatInputSignal;
        [Inject]
        public var closeCurrentPopup:CloseCurrentPopupSignal;
        [Inject]
        public var enterGame:EnterGameSignal;
        [Inject]
        public var playerModel:PlayerModel;
        [Inject]
        public var playGame:PlayGameSignal;


        override public function initialize():void{
            if (this.view.removeButton){
                this.view.removeButton.addEventListener(MouseEvent.CLICK, this.onRemoveClick);
            }
            if (this.view.acceptButton){
                this.view.acceptButton.addEventListener(MouseEvent.CLICK, this.onAcceptClick);
            }
            if (this.view.rejectButton){
                this.view.rejectButton.addEventListener(MouseEvent.CLICK, this.onRejectClick);
            }
            if (this.view.messageButton){
                this.view.messageButton.addEventListener(MouseEvent.CLICK, this.onMessageClick);
            }
            if (this.view.teleportButton){
                this.view.teleportButton.addEventListener(MouseEvent.CLICK, this.onTeleportClick);
            }
            if (this.view.blockButton){
                this.view.blockButton.addEventListener(MouseEvent.CLICK, this.onBlockClick);
            }
        }

        private function onMessageClick(_arg1:MouseEvent):void{
            this.chatSignal.dispatch(true, (("/tell " + this.view.getLabelText()) + " "));
            this.closeCurrentPopup.dispatch();
        }

        override public function destroy():void{
            if (this.view.removeButton){
                this.view.removeButton.removeEventListener(MouseEvent.CLICK, this.onRemoveClick);
            }
            if (this.view.acceptButton){
                this.view.acceptButton.removeEventListener(MouseEvent.CLICK, this.onAcceptClick);
            }
            if (this.view.rejectButton){
                this.view.rejectButton.removeEventListener(MouseEvent.CLICK, this.onRejectClick);
            }
            if (this.view.messageButton){
                this.view.messageButton.removeEventListener(MouseEvent.CLICK, this.onMessageClick);
            }
            if (this.view.teleportButton){
                this.view.teleportButton.removeEventListener(MouseEvent.CLICK, this.onTeleportClick);
            }
            if (this.view.blockButton){
                this.view.blockButton.removeEventListener(MouseEvent.CLICK, this.onBlockClick);
            }
        }

        private function onTeleportClick(_arg1:MouseEvent):void{
            var _local3:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
            Parameters.data_.preferredServer = this.view.vo.getServerName();
            Parameters.save();
            this.enterGame.dispatch();
            var _local4:GameInitData = new GameInitData();
            _local4.createCharacter = false;
            _local4.charId = _local3.charId();
            _local4.isNewGame = true;
            this.playGame.dispatch(_local4);
            this.closeCurrentPopup.dispatch();
        }

        private function onRemoveConfirmed(_arg1:BaseButton):void{
            var _local2:FriendRequestVO = new FriendRequestVO(FriendsActions.REMOVE, this.view.getLabelText(), this.onRemoveCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }

        private function onBlockConfirmed(_arg1:BaseButton):void{
            var _local2:FriendRequestVO = new FriendRequestVO(FriendsActions.BLOCK, this.view.getLabelText(), this.onBlockCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }

        private function onRemoveCallback(_arg1:Boolean, _arg2:Object, _arg3:String):void{
            if (_arg1){
                this.model.removeFriend(_arg3);
            }
            else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST, _arg1);
        }

        private function onBlockCallback(_arg1:Boolean, _arg2:Object, _arg3:String):void{
            if (_arg1){
                this.model.removeInvitation(_arg3);
            }
            else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST, _arg1);
        }

        private function onAcceptCallback(_arg1:Boolean, _arg2:Object, _arg3:String):void{
            if (_arg1){
                this.model.removeInvitation(_arg3);
                this.model.seedFriends(XML(_arg2));
            }
            else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST, _arg1);
        }

        private function onRejectCallback(_arg1:Boolean, _arg2:Object, _arg3:String):void{
            if (_arg1){
                this.model.removeInvitation(_arg3);
            }
            else {
                this.showPopup.dispatch(new ErrorModal(350, "Friends List Error", LineBuilder.getLocalizedStringFromKey(String(_arg2))));
            }
            this.removeFade.dispatch();
            this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST, _arg1);
        }

        private function onRemoveClick(_arg1:MouseEvent):void{
            var _local2:ConfirmationModal = new ConfirmationModal(350, LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_REMOVE_TITLE), LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_REMOVE_TEXT, {name:this.view.getLabelText()}), LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_REMOVE_BUTTON), LineBuilder.getLocalizedStringFromKey(TextKey.FRAME_CANCEL), 130);
            _local2.confirmButton.clickSignal.addOnce(this.onRemoveConfirmed);
            this.showPopupSignal.dispatch(_local2);
        }

        private function onAcceptClick(_arg1:MouseEvent):void{
            var _local2:FriendRequestVO = new FriendRequestVO(FriendsActions.ACCEPT, this.view.getLabelText(), this.onAcceptCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }

        private function onRejectClick(_arg1:MouseEvent):void{
            var _local2:FriendRequestVO = new FriendRequestVO(FriendsActions.REJECT, this.view.getLabelText(), this.onRejectCallback);
            this.friendsAction.dispatch(_local2);
            this.showFade.dispatch();
        }

        private function onBlockClick(_arg1:MouseEvent):void{
            var _local2:ConfirmationModal = new ConfirmationModal(350, LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_BLOCK_TITLE), LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_BLOCK_TEXT, {name:this.view.getLabelText()}), LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_BLOCK_BUTTON), LineBuilder.getLocalizedStringFromKey(TextKey.FRAME_CANCEL), 130);
            _local2.confirmButton.clickSignal.addOnce(this.onBlockConfirmed);
            this.showPopupSignal.dispatch(_local2);
        }


    }
}//package io.decagames.rotmg.social.widgets

