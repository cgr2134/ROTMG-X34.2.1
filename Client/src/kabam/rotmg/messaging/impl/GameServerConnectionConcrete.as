﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.messaging.impl.GameServerConnectionConcrete

package kabam.rotmg.messaging.impl{
import flash.net.Socket;
import flash.utils.Endian;

import kabam.lib.net.api.MessageProvider;
    import com.company.assembleegameclient.objects.Player;
    import com.company.util.Random;
    import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
    import kabam.rotmg.messaging.impl.incoming.Death;
    import flash.utils.Timer;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
    import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
    import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
    import robotlegs.bender.framework.api.ILogger;
    import kabam.rotmg.death.control.HandleDeathSignal;
    import kabam.rotmg.death.control.ZombifySignal;
    import kabam.rotmg.game.focus.control.SetGameFocusSignal;
    import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
    import io.decagames.rotmg.pets.signals.PetFeedResultSignal;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    import kabam.rotmg.arena.control.ArenaDeathSignal;
    import kabam.rotmg.arena.control.ImminentArenaWaveSignal;
    import io.decagames.rotmg.dailyQuests.signal.QuestFetchCompleteSignal;
    import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
    import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
    import kabam.rotmg.dailyLogin.signal.ClaimDailyRewardResponseSignal;
    import io.decagames.rotmg.classes.NewClassUnlockSignal;
    import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
    import kabam.rotmg.ui.signals.RealmHeroesSignal;
    import kabam.rotmg.ui.signals.RealmQuestLevelSignal;
    import kabam.rotmg.arena.model.CurrentArenaRunModel;
    import kabam.rotmg.classes.model.ClassesModel;
    import org.swiftsuspenders.Injector;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.ui.model.HUDModel;
    import io.decagames.rotmg.pets.signals.UpdateActivePet;
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.social.model.SocialModel;
    import kabam.rotmg.servers.api.ServerModel;
    import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.maploading.signals.ChangeMapSignal;
    import kabam.lib.net.impl.SocketServer;
    import com.company.assembleegameclient.game.AGameSprite;
    import kabam.rotmg.servers.api.Server;
    import flash.utils.ByteArray;
    import kabam.rotmg.chat.model.ChatMessage;
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.lib.net.api.MessageMap;
    import kabam.rotmg.messaging.impl.outgoing.Create;
    import kabam.rotmg.messaging.impl.outgoing.PlayerShoot;
    import kabam.rotmg.messaging.impl.outgoing.Move;
    import kabam.rotmg.messaging.impl.outgoing.PlayerText;
    import kabam.lib.net.impl.Message;
    import kabam.rotmg.messaging.impl.outgoing.InvSwap;
    import kabam.rotmg.messaging.impl.outgoing.UseItem;
    import kabam.rotmg.messaging.impl.outgoing.Hello;
    import kabam.rotmg.messaging.impl.outgoing.InvDrop;
    import kabam.rotmg.messaging.impl.outgoing.Pong;
    import kabam.rotmg.messaging.impl.outgoing.Load;
    import kabam.rotmg.messaging.impl.outgoing.SetCondition;
    import kabam.rotmg.messaging.impl.outgoing.Teleport;
    import kabam.rotmg.messaging.impl.outgoing.UsePortal;
    import kabam.rotmg.messaging.impl.outgoing.Buy;
    import kabam.rotmg.messaging.impl.outgoing.PlayerHit;
    import kabam.rotmg.messaging.impl.outgoing.EnemyHit;
    import kabam.rotmg.messaging.impl.outgoing.AoeAck;
    import kabam.rotmg.messaging.impl.outgoing.ShootAck;
    import kabam.rotmg.messaging.impl.outgoing.OtherHit;
    import kabam.rotmg.messaging.impl.outgoing.SquareHit;
    import kabam.rotmg.messaging.impl.outgoing.GotoAck;
    import kabam.rotmg.messaging.impl.outgoing.GroundDamage;
    import kabam.rotmg.messaging.impl.outgoing.ChooseName;
    import kabam.rotmg.messaging.impl.outgoing.CreateGuild;
    import kabam.rotmg.messaging.impl.outgoing.GuildRemove;
    import kabam.rotmg.messaging.impl.outgoing.GuildInvite;
    import kabam.rotmg.messaging.impl.outgoing.RequestTrade;
    import kabam.rotmg.messaging.impl.outgoing.ChangeTrade;
    import kabam.rotmg.messaging.impl.outgoing.AcceptTrade;
    import kabam.rotmg.messaging.impl.outgoing.CancelTrade;
    import kabam.rotmg.messaging.impl.outgoing.CheckCredits;
    import kabam.rotmg.messaging.impl.outgoing.Escape;
    import kabam.rotmg.messaging.impl.outgoing.GoToQuestRoom;
    import kabam.rotmg.messaging.impl.outgoing.JoinGuild;
    import kabam.rotmg.messaging.impl.outgoing.ChangeGuildRank;
    import kabam.rotmg.messaging.impl.outgoing.EditAccountList;
    import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
    import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
    import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
    import kabam.rotmg.messaging.impl.outgoing.arena.QuestRedeem;
    import kabam.rotmg.messaging.impl.outgoing.ResetDailyQuests;
    import kabam.rotmg.messaging.impl.outgoing.KeyInfoRequest;
    import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
    import kabam.rotmg.messaging.impl.outgoing.ChangePetSkin;
    import kabam.rotmg.messaging.impl.incoming.Failure;
    import kabam.rotmg.messaging.impl.incoming.CreateSuccess;
    import kabam.rotmg.messaging.impl.incoming.ServerPlayerShoot;
    import kabam.rotmg.messaging.impl.incoming.Damage;
    import kabam.rotmg.messaging.impl.incoming.Update;
    import kabam.rotmg.messaging.impl.incoming.Notification;
    import kabam.rotmg.messaging.impl.incoming.GlobalNotification;
    import kabam.rotmg.messaging.impl.incoming.NewTick;
    import kabam.rotmg.messaging.impl.incoming.ShowEffect;
    import kabam.rotmg.messaging.impl.incoming.Goto;
    import kabam.rotmg.messaging.impl.incoming.InvResult;
    import kabam.rotmg.messaging.impl.incoming.Reconnect;
    import kabam.rotmg.messaging.impl.incoming.Ping;
    import kabam.rotmg.messaging.impl.incoming.MapInfo;
    import kabam.rotmg.messaging.impl.incoming.Pic;
    import kabam.rotmg.messaging.impl.incoming.BuyResult;
    import kabam.rotmg.messaging.impl.incoming.Aoe;
    import kabam.rotmg.messaging.impl.incoming.AccountList;
    import kabam.rotmg.messaging.impl.incoming.QuestObjId;
    import kabam.rotmg.messaging.impl.incoming.NameResult;
    import kabam.rotmg.messaging.impl.incoming.GuildResult;
    import kabam.rotmg.messaging.impl.incoming.AllyShoot;
    import kabam.rotmg.messaging.impl.incoming.EnemyShoot;
    import kabam.rotmg.messaging.impl.incoming.TradeRequested;
    import kabam.rotmg.messaging.impl.incoming.TradeStart;
    import kabam.rotmg.messaging.impl.incoming.TradeChanged;
    import kabam.rotmg.messaging.impl.incoming.TradeDone;
    import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
    import kabam.rotmg.messaging.impl.incoming.ClientStat;
    import kabam.rotmg.messaging.impl.incoming.File;
    import kabam.rotmg.messaging.impl.incoming.InvitedToGuild;
    import kabam.rotmg.messaging.impl.incoming.PlaySound;
    import kabam.rotmg.messaging.impl.incoming.NewAbilityMessage;
    import kabam.rotmg.messaging.impl.incoming.EvolvedPetMessage;
    import kabam.rotmg.messaging.impl.incoming.pets.DeletePetMessage;
    import kabam.rotmg.messaging.impl.incoming.pets.HatchPetMessage;
    import kabam.rotmg.messaging.impl.incoming.arena.ImminentArenaWave;
    import kabam.rotmg.messaging.impl.incoming.arena.ArenaDeath;
    import kabam.rotmg.messaging.impl.incoming.VerifyEmail;
    import kabam.rotmg.messaging.impl.incoming.ReskinUnlock;
    import kabam.rotmg.messaging.impl.incoming.PasswordPrompt;
    import io.decagames.rotmg.dailyQuests.messages.incoming.QuestFetchResponse;
    import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
    import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
    import kabam.rotmg.dailyLogin.message.ClaimDailyRewardResponse;
    import kabam.rotmg.messaging.impl.incoming.RealmHeroesResponse;
    import io.decagames.rotmg.pets.signals.HatchPetSignal;
    import io.decagames.rotmg.pets.data.vo.HatchPetVO;
    import io.decagames.rotmg.pets.signals.DeletePetSignal;
    import io.decagames.rotmg.pets.signals.NewAbilitySignal;
    import io.decagames.rotmg.pets.signals.UpdatePetYardSignal;
    import kabam.rotmg.messaging.impl.incoming.EvolvedMessageHandler;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.Crypto;
    import com.company.util.MoreStringUtil;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.arena.view.BattleSummaryDialog;
    import com.company.assembleegameclient.objects.Projectile;
    import com.company.assembleegameclient.sound.SoundEffectLibrary;
    import com.company.assembleegameclient.objects.GameObject;
    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.game.model.PotionInventoryModel;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.utils.getTimer;
    import com.company.assembleegameclient.objects.SellableObject;
    import com.company.assembleegameclient.util.Currency;
    import kabam.rotmg.account.core.view.PurchaseConfirmationDialog;
    import com.hurlant.util.der.PEM;
    import com.hurlant.crypto.rsa.RSAKey;
    import com.hurlant.util.Base64;
    import kabam.rotmg.account.core.Account;
    import com.company.assembleegameclient.map.AbstractMap;
    import com.company.assembleegameclient.util.FreeList;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.CharacterSkinState;
    import com.company.assembleegameclient.ui.panels.TradeRequestPanel;
    import kabam.rotmg.messaging.impl.data.ObjectStatusData;
    import kabam.rotmg.ui.model.UpdateGameObjectTileVO;
    import kabam.rotmg.messaging.impl.data.ObjectData;
    import kabam.rotmg.messaging.impl.data.GroundTileData;
    import kabam.rotmg.minimap.model.UpdateGroundTileVO;
    import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
    import kabam.rotmg.ui.signals.ShowKeySignal;
    import kabam.rotmg.ui.model.Key;
    import com.company.assembleegameclient.objects.particles.ParticleEffect;
    import flash.geom.Point;
    import com.company.assembleegameclient.objects.particles.HealEffect;
    import com.company.assembleegameclient.objects.particles.TeleportEffect;
    import com.company.assembleegameclient.objects.particles.StreamEffect;
    import com.company.assembleegameclient.objects.particles.ThrowEffect;
    import com.company.assembleegameclient.objects.particles.NovaEffect;
    import com.company.assembleegameclient.objects.particles.PoisonEffect;
    import com.company.assembleegameclient.objects.particles.LineEffect;
    import com.company.assembleegameclient.objects.particles.BurstEffect;
    import com.company.assembleegameclient.objects.particles.FlowEffect;
    import com.company.assembleegameclient.objects.particles.RingEffect;
    import com.company.assembleegameclient.objects.particles.LightningEffect;
    import com.company.assembleegameclient.objects.particles.CollapseEffect;
    import com.company.assembleegameclient.objects.particles.ConeBlastEffect;
    import com.company.assembleegameclient.objects.FlashDescription;
    import com.company.assembleegameclient.objects.thrown.ThrowProjectileEffect;
    import com.company.assembleegameclient.objects.particles.InspireEffect;
    import com.company.assembleegameclient.objects.particles.SpritesProjectEffect;
    import com.company.assembleegameclient.objects.particles.ShockerEffect;
    import com.company.assembleegameclient.objects.particles.ShockeeEffect;
    import com.company.assembleegameclient.objects.particles.RisingFuryEffect;
    import com.company.assembleegameclient.objects.particles.GildedEffect;
    import com.company.assembleegameclient.objects.particles.ThunderEffect;
    import com.company.assembleegameclient.objects.StatusFlashDescription;
    import com.company.assembleegameclient.objects.particles.OrbEffect;
    import kabam.rotmg.messaging.impl.data.StatData;
    import com.company.assembleegameclient.objects.Merchant;
    import com.company.assembleegameclient.objects.Pet;
    import com.company.assembleegameclient.util.ConditionEffect;
    import com.company.assembleegameclient.objects.Portal;
    import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
    import com.company.assembleegameclient.objects.Container;
    import com.company.assembleegameclient.objects.NameChanger;
    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.messaging.impl.outgoing.Reskin;
    import com.company.assembleegameclient.objects.ObjectProperties;
    import com.company.assembleegameclient.objects.ProjectileProperties;
    import com.company.assembleegameclient.game.events.ReconnectEvent;
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.ui.PicView;
    import flash.display.BitmapData;
    import kabam.rotmg.ui.view.NotEnoughGoldDialog;
    import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
    import com.company.assembleegameclient.objects.particles.AOEEffect;
    import com.company.assembleegameclient.game.events.NameResultEvent;
    import com.company.assembleegameclient.game.events.GuildResultEvent;
    import flash.net.FileReference;
    import com.company.assembleegameclient.ui.panels.GuildInvitePanel;
    import kabam.rotmg.arena.view.ContinueOrQuitDialog;
    import kabam.rotmg.ui.view.TitleView;
    import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import flash.events.TimerEvent;
    import com.company.assembleegameclient.ui.dialogs.Dialog;
    import flash.events.Event;
    import com.company.assembleegameclient.objects.*;
    import kabam.rotmg.messaging.impl.incoming.*;
    import kabam.rotmg.messaging.impl.data.*;
    import com.company.assembleegameclient.objects.particles.*;
    import kabam.rotmg.messaging.impl.outgoing.*;

    public class GameServerConnectionConcrete extends GameServerConnection {

        private static const TO_MILLISECONDS:int = 1000;

        public static var connectionGuid:String = "";
        public static var lastConnectionFailureMessage:String = "";
        public static var lastConnectionFailureID:String = "";

        private var petUpdater:PetUpdater;
        private var messages:MessageProvider;
        private var playerId_:int = -1;
        private var player:Player;
        private var retryConnection_:Boolean = true;
        private var serverFull_:Boolean = false;
        private var rand_:Random = null;
        private var giftChestUpdateSignal:GiftStatusUpdateSignal;
        private var death:Death;
        private var retryTimer_:Timer;
        private var delayBeforeReconnect:int = 2;
        private var addTextLine:AddTextLineSignal;
        private var addSpeechBalloon:AddSpeechBalloonSignal;
        private var updateGroundTileSignal:UpdateGroundTileSignal;
        private var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
        private var logger:ILogger;
        private var handleDeath:HandleDeathSignal;
        private var zombify:ZombifySignal;
        private var setGameFocus:SetGameFocusSignal;
        private var updateBackpackTab:UpdateBackpackTabSignal;
        private var petFeedResult:PetFeedResultSignal;
        private var closeDialogs:CloseDialogsSignal;
        private var openDialog:OpenDialogSignal;
        private var showPopupSignal:ShowPopupSignal;
        private var arenaDeath:ArenaDeathSignal;
        private var imminentWave:ImminentArenaWaveSignal;
        private var questFetchComplete:QuestFetchCompleteSignal;
        private var questRedeemComplete:QuestRedeemCompleteSignal;
        private var keyInfoResponse:KeyInfoResponseSignal;
        private var claimDailyRewardResponse:ClaimDailyRewardResponseSignal;
        private var newClassUnlockSignal:NewClassUnlockSignal;
        private var showHideKeyUISignal:ShowHideKeyUISignal;
        private var realmHeroesSignal:RealmHeroesSignal;
        private var realmQuestLevelSignal:RealmQuestLevelSignal;
        private var currentArenaRun:CurrentArenaRunModel;
        private var classesModel:ClassesModel;
        private var injector:Injector;
        private var model:GameModel;
        private var hudModel:HUDModel;
        private var updateActivePet:UpdateActivePet;
        private var petsModel:PetsModel;
        private var socialModel:SocialModel;
        private var isNexusing:Boolean;
        private var serverModel:ServerModel;
        private var statsTracker:CharactersMetricsTracker;

        public function GameServerConnectionConcrete(_arg1:AGameSprite, _arg2:Server, _arg3:int, _arg4:Boolean, _arg5:int, _arg6:int, _arg7:ByteArray, _arg8:String, _arg9:Boolean){
            this.injector = StaticInjectorContext.getInjector();
            this.giftChestUpdateSignal = this.injector.getInstance(GiftStatusUpdateSignal);
            this.addTextLine = this.injector.getInstance(AddTextLineSignal);
            this.addSpeechBalloon = this.injector.getInstance(AddSpeechBalloonSignal);
            this.updateGroundTileSignal = this.injector.getInstance(UpdateGroundTileSignal);
            this.updateGameObjectTileSignal = this.injector.getInstance(UpdateGameObjectTileSignal);
            this.petFeedResult = this.injector.getInstance(PetFeedResultSignal);
            this.updateBackpackTab = StaticInjectorContext.getInjector().getInstance(UpdateBackpackTabSignal);
            this.updateActivePet = this.injector.getInstance(UpdateActivePet);
            this.petsModel = this.injector.getInstance(PetsModel);
            this.socialModel = this.injector.getInstance(SocialModel);
            this.closeDialogs = this.injector.getInstance(CloseDialogsSignal);
            changeMapSignal = this.injector.getInstance(ChangeMapSignal);
            this.openDialog = this.injector.getInstance(OpenDialogSignal);
            this.showPopupSignal = this.injector.getInstance(ShowPopupSignal);
            this.arenaDeath = this.injector.getInstance(ArenaDeathSignal);
            this.imminentWave = this.injector.getInstance(ImminentArenaWaveSignal);
            this.questFetchComplete = this.injector.getInstance(QuestFetchCompleteSignal);
            this.questRedeemComplete = this.injector.getInstance(QuestRedeemCompleteSignal);
            this.keyInfoResponse = this.injector.getInstance(KeyInfoResponseSignal);
            this.claimDailyRewardResponse = this.injector.getInstance(ClaimDailyRewardResponseSignal);
            this.newClassUnlockSignal = this.injector.getInstance(NewClassUnlockSignal);
            this.showHideKeyUISignal = this.injector.getInstance(ShowHideKeyUISignal);
            this.realmHeroesSignal = this.injector.getInstance(RealmHeroesSignal);
            this.realmQuestLevelSignal = this.injector.getInstance(RealmQuestLevelSignal);
            this.statsTracker = this.injector.getInstance(CharactersMetricsTracker);
            this.logger = this.injector.getInstance(ILogger);
            this.handleDeath = this.injector.getInstance(HandleDeathSignal);
            this.zombify = this.injector.getInstance(ZombifySignal);
            this.setGameFocus = this.injector.getInstance(SetGameFocusSignal);
            this.classesModel = this.injector.getInstance(ClassesModel);
            serverConnection = this.injector.getInstance(SocketServer);
            this.messages = this.injector.getInstance(MessageProvider);
            this.model = this.injector.getInstance(GameModel);
            this.hudModel = this.injector.getInstance(HUDModel);
            this.serverModel = this.injector.getInstance(ServerModel);
            this.currentArenaRun = this.injector.getInstance(CurrentArenaRunModel);
            gs_ = _arg1;
            server_ = _arg2;
            gameId_ = _arg3;
            createCharacter_ = _arg4;
            charId_ = _arg5;
            keyTime_ = _arg6;
            key_ = _arg7;
            mapJSON_ = _arg8;
            isFromArena_ = _arg9;
            this.socialModel.loadInvitations();
            this.socialModel.setCurrentServer(server_);
            this.getPetUpdater();
            instance = this;
        }

        private static function isStatPotion(_arg1:int):Boolean{
            return ((((((((((((((((((((((_arg1 == 2591)) || ((_arg1 == 5465)))) || ((_arg1 == 9064)))) || ((((((_arg1 == 2592)) || ((_arg1 == 5466)))) || ((_arg1 == 9065)))))) || ((((((_arg1 == 2593)) || ((_arg1 == 5467)))) || ((_arg1 == 9066)))))) || ((((((_arg1 == 2612)) || ((_arg1 == 5468)))) || ((_arg1 == 9067)))))) || ((((((_arg1 == 2613)) || ((_arg1 == 5469)))) || ((_arg1 == 9068)))))) || ((((((_arg1 == 2636)) || ((_arg1 == 5470)))) || ((_arg1 == 9069)))))) || ((((((_arg1 == 2793)) || ((_arg1 == 5471)))) || ((_arg1 == 9070)))))) || ((((((_arg1 == 2794)) || ((_arg1 == 5472)))) || ((_arg1 == 9071)))))) || ((((((((((((((((_arg1 == 9724)) || ((_arg1 == 9725)))) || ((_arg1 == 9726)))) || ((_arg1 == 9727)))) || ((_arg1 == 0x2600)))) || ((_arg1 == 9729)))) || ((_arg1 == 9730)))) || ((_arg1 == 9731))))));
        }


        private function getPetUpdater():void{
            this.injector.map(AGameSprite).toValue(gs_);
            this.petUpdater = this.injector.getInstance(PetUpdater);
            this.injector.unmap(AGameSprite);
        }

        override public function disconnect():void{
            this.removeServerConnectionListeners();
            this.unmapMessages();
            serverConnection.disconnect();
        }

        private function removeServerConnectionListeners():void{
            serverConnection.connected.remove(this.onConnected);
            serverConnection.closed.remove(this.onClosed);
            serverConnection.error.remove(this.onError);
        }

        override public function connect():void{
            this.addServerConnectionListeners();
            this.mapMessages();
            var _local1:ChatMessage = new ChatMessage();
            _local1.name = Parameters.CLIENT_CHAT_NAME;
            _local1.text = TextKey.CHAT_CONNECTING_TO;
            var _local2:String = server_.name;
            if (_local2 == '{"text":"server.vault"}'){
                _local2 = "server.vault";
            }
            _local2 = LineBuilder.getLocalizedStringFromKey(_local2);
            _local1.tokens = {serverName:_local2};
            this.addTextLine.dispatch(_local1);
            serverConnection.connect(server_.address, server_.port, this);
        }

        public function addServerConnectionListeners():void{
            serverConnection.connected.add(this.onConnected);
            serverConnection.closed.add(this.onClosed);
            serverConnection.error.add(this.onError);
        }

        public override function handleMessage(id:int, socket:Socket):Boolean{
            switch(id){
                case CREATE_SUCCESS: onCreateSuccess(socket); return true;
                case SERVERPLAYERSHOOT: onServerPlayerShoot(socket); return true;
                case DAMAGE: onDamage(socket); return true;
                case UPDATE: onUpdate(socket); return true;
                case NOTIFICATION: onNotification(socket); return true;
                case GLOBAL_NOTIFICATION: onGlobalNotification(socket); return true;
                case NEWTICK: onNewTick(socket); return true;
                case SHOWEFFECT: onShowEffect(socket); return true;
                case GOTO: onGoto(socket); return true;
                case INVRESULT: onInvResult(socket); return true;
                case RECONNECT: onReconnect(socket); return true;
                case PING: onPing(socket); return true;
                case MAPINFO: onMapInfo(socket); return true;
//                case PIC: onPic(socket); break;
//                case DEATH: onDeath(socket); break;
//                case BUYRESULT: onBuyResult(socket); break;
//                case AOE: onAoe(socket); break;
//                case ACCOUNTLIST: onAccountList(socket); break;
//                case QUESTOBJID: onQuestObjId(socket); break;
//                case NAMERESULT: onNameResult(socket); break;
//                case GUILDRESULT: onGuildResult(socket); break;
//                case ALLYSHOOT: onAllyShoot(socket); break;
//                case ENEMYSHOOT: onEnemyShoot(socket); break;
//                case TRADEREQUESTED: onTradeRequested(socket); break;
//                case TRADESTART: onTradeStart(socket); break;
//                case TRADECHANGED: onTradeChanged(socket); break;
//                case TRADEDONE: onTradeDone(socket); break;
//                case TRADEACCEPTED: onTradeAccepted(socket); break;
//                case CLIENTSTAT: onClientStat(socket); break;
//                case FILE: onFile(socket); break;
//                case INVITEDTOGUILD: onInvitedToGuild(socket); break;
//                case PLAYSOUND: onPlaySound(socket); break;
//                case ACTIVEPETUPDATE: onActivePetUpdate(socket); break;
//                case NEW_ABILITY: onNewAbility(socket); break;
//                case PETYARDUPDATE: onPetYardUpdate(socket); break;
//                case EVOLVE_PET: onEvolvedPet(socket); break;
//                case DELETE_PET: onDeletePet(socket); break;
//                case HATCH_PET: onHatchPet(socket); break;
//                case IMMINENT_ARENA_WAVE: onImminentArenaWave(socket); break;
//                case ARENA_DEATH: onArenaDeath(socket); break;
//                case VERIFY_EMAIL: onVerifyEmail(socket); break;
//                case RESKIN_UNLOCK: onReskinUnlock(socket); break;
//                case PASSWORD_PROMPT: onPasswordPrompt(socket); break;
//                case QUEST_FETCH_RESPONSE: onQuestFetchResponse(socket); break;
//                case QUEST_REDEEM_RESPONSE: onQuestRedeemResponse(socket); break;
//                case KEY_INFO_RESPONSE: onKeyInfoResponse(socket); break;
//                case LOGIN_REWARD_MSG: onLoginRewardResponse(socket); break;
//                case REALM_HERO_LEFT_MSG: onRealmHeroesResponse(socket); break;
            }
            return false;
        }

        public function mapMessages():void{
            var _local1:MessageMap = this.injector.getInstance(MessageMap);
            _local1.map(CREATE).toMessage(Create);
            _local1.map(PLAYERSHOOT).toMessage(PlayerShoot);
            _local1.map(MOVE).toMessage(Move);
            _local1.map(PLAYERTEXT).toMessage(PlayerText);
            _local1.map(UPDATEACK).toMessage(Message);
            _local1.map(INVSWAP).toMessage(InvSwap);
            _local1.map(USEITEM).toMessage(UseItem);
            _local1.map(HELLO).toMessage(Hello);
            _local1.map(INVDROP).toMessage(InvDrop);
            _local1.map(PONG).toMessage(Pong);
            _local1.map(LOAD).toMessage(Load);
            _local1.map(SETCONDITION).toMessage(SetCondition);
            _local1.map(TELEPORT).toMessage(Teleport);
            _local1.map(USEPORTAL).toMessage(UsePortal);
            _local1.map(BUY).toMessage(Buy);
            _local1.map(PLAYERHIT).toMessage(PlayerHit);
            _local1.map(ENEMYHIT).toMessage(EnemyHit);
            _local1.map(AOEACK).toMessage(AoeAck);
            _local1.map(SHOOTACK).toMessage(ShootAck);
            _local1.map(OTHERHIT).toMessage(OtherHit);
            _local1.map(SQUAREHIT).toMessage(SquareHit);
            _local1.map(GOTOACK).toMessage(GotoAck);
            _local1.map(GROUNDDAMAGE).toMessage(GroundDamage);
            _local1.map(CHOOSENAME).toMessage(ChooseName);
            _local1.map(CREATEGUILD).toMessage(CreateGuild);
            _local1.map(GUILDREMOVE).toMessage(GuildRemove);
            _local1.map(GUILDINVITE).toMessage(GuildInvite);
            _local1.map(REQUESTTRADE).toMessage(RequestTrade);
            _local1.map(CHANGETRADE).toMessage(ChangeTrade);
            _local1.map(ACCEPTTRADE).toMessage(AcceptTrade);
            _local1.map(CANCELTRADE).toMessage(CancelTrade);
            _local1.map(CHECKCREDITS).toMessage(CheckCredits);
            _local1.map(ESCAPE).toMessage(Escape);
            _local1.map(QUEST_ROOM_MSG).toMessage(GoToQuestRoom);
            _local1.map(JOINGUILD).toMessage(JoinGuild);
            _local1.map(CHANGEGUILDRANK).toMessage(ChangeGuildRank);
            _local1.map(EDITACCOUNTLIST).toMessage(EditAccountList);
            _local1.map(ACTIVE_PET_UPDATE_REQUEST).toMessage(ActivePetUpdateRequest);
            _local1.map(PETUPGRADEREQUEST).toMessage(PetUpgradeRequest);
            _local1.map(ENTER_ARENA).toMessage(EnterArena);
            _local1.map(ACCEPT_ARENA_DEATH).toMessage(OutgoingMessage);
            _local1.map(QUEST_FETCH_ASK).toMessage(OutgoingMessage);
            _local1.map(QUEST_REDEEM).toMessage(QuestRedeem);
            _local1.map(RESET_DAILY_QUESTS).toMessage(ResetDailyQuests);
            _local1.map(KEY_INFO_REQUEST).toMessage(KeyInfoRequest);
            _local1.map(PET_CHANGE_FORM_MSG).toMessage(ReskinPet);
            _local1.map(CLAIM_LOGIN_REWARD_MSG).toMessage(ClaimDailyRewardMessage);
            _local1.map(PET_CHANGE_SKIN_MSG).toMessage(ChangePetSkin);
            _local1.map(FAILURE).toMessage(Failure).toMethod(this.onFailure);
//            _local1.map(CREATE_SUCCESS).toMessage(CreateSuccess).toMethod(this.onCreateSuccess);
//            _local1.map(SERVERPLAYERSHOOT).toMessage(ServerPlayerShoot).toMethod(this.onServerPlayerShoot);
//            _local1.map(DAMAGE).toMessage(Damage).toMethod(this.onDamage);
//            _local1.map(UPDATE).toMessage(Update).toMethod(this.onUpdate);
//            _local1.map(NOTIFICATION).toMessage(Notification).toMethod(this.onNotification);
//            _local1.map(GLOBAL_NOTIFICATION).toMessage(GlobalNotification).toMethod(this.onGlobalNotification);
//            _local1.map(NEWTICK).toMessage(NewTick).toMethod(this.onNewTick);
//            _local1.map(SHOWEFFECT).toMessage(ShowEffect).toMethod(this.onShowEffect);
//            _local1.map(GOTO).toMessage(Goto).toMethod(this.onGoto);
//            _local1.map(INVRESULT).toMessage(InvResult).toMethod(this.onInvResult);
//            _local1.map(RECONNECT).toMessage(Reconnect).toMethod(this.onReconnect);
//            _local1.map(PING).toMessage(Ping).toMethod(this.onPing);
//            _local1.map(MAPINFO).toMessage(MapInfo).toMethod(this.onMapInfo);
            _local1.map(PIC).toMessage(Pic).toMethod(this.onPic);
            _local1.map(DEATH).toMessage(Death).toMethod(this.onDeath);
            _local1.map(BUYRESULT).toMessage(BuyResult).toMethod(this.onBuyResult);
            _local1.map(AOE).toMessage(Aoe).toMethod(this.onAoe);
            _local1.map(ACCOUNTLIST).toMessage(AccountList).toMethod(this.onAccountList);
            _local1.map(QUESTOBJID).toMessage(QuestObjId).toMethod(this.onQuestObjId);
            _local1.map(NAMERESULT).toMessage(NameResult).toMethod(this.onNameResult);
            _local1.map(GUILDRESULT).toMessage(GuildResult).toMethod(this.onGuildResult);
            _local1.map(ALLYSHOOT).toMessage(AllyShoot).toMethod(this.onAllyShoot);
            _local1.map(ENEMYSHOOT).toMessage(EnemyShoot).toMethod(this.onEnemyShoot);
            _local1.map(TRADEREQUESTED).toMessage(TradeRequested).toMethod(this.onTradeRequested);
            _local1.map(TRADESTART).toMessage(TradeStart).toMethod(this.onTradeStart);
            _local1.map(TRADECHANGED).toMessage(TradeChanged).toMethod(this.onTradeChanged);
            _local1.map(TRADEDONE).toMessage(TradeDone).toMethod(this.onTradeDone);
            _local1.map(TRADEACCEPTED).toMessage(TradeAccepted).toMethod(this.onTradeAccepted);
            _local1.map(CLIENTSTAT).toMessage(ClientStat).toMethod(this.onClientStat);
            _local1.map(FILE).toMessage(File).toMethod(this.onFile);
            _local1.map(INVITEDTOGUILD).toMessage(InvitedToGuild).toMethod(this.onInvitedToGuild);
            _local1.map(PLAYSOUND).toMessage(PlaySound).toMethod(this.onPlaySound);
            _local1.map(ACTIVEPETUPDATE).toMessage(ActivePet).toMethod(this.onActivePetUpdate);
            _local1.map(NEW_ABILITY).toMessage(NewAbilityMessage).toMethod(this.onNewAbility);
            _local1.map(PETYARDUPDATE).toMessage(PetYard).toMethod(this.onPetYardUpdate);
            _local1.map(EVOLVE_PET).toMessage(EvolvedPetMessage).toMethod(this.onEvolvedPet);
            _local1.map(DELETE_PET).toMessage(DeletePetMessage).toMethod(this.onDeletePet);
            _local1.map(HATCH_PET).toMessage(HatchPetMessage).toMethod(this.onHatchPet);
            _local1.map(IMMINENT_ARENA_WAVE).toMessage(ImminentArenaWave).toMethod(this.onImminentArenaWave);
            _local1.map(ARENA_DEATH).toMessage(ArenaDeath).toMethod(this.onArenaDeath);
            _local1.map(VERIFY_EMAIL).toMessage(VerifyEmail).toMethod(this.onVerifyEmail);
            _local1.map(RESKIN_UNLOCK).toMessage(ReskinUnlock).toMethod(this.onReskinUnlock);
            _local1.map(PASSWORD_PROMPT).toMessage(PasswordPrompt).toMethod(this.onPasswordPrompt);
            _local1.map(QUEST_FETCH_RESPONSE).toMessage(QuestFetchResponse).toMethod(this.onQuestFetchResponse);
            _local1.map(QUEST_REDEEM_RESPONSE).toMessage(QuestRedeemResponse).toMethod(this.onQuestRedeemResponse);
            _local1.map(KEY_INFO_RESPONSE).toMessage(KeyInfoResponse).toMethod(this.onKeyInfoResponse);
            _local1.map(LOGIN_REWARD_MSG).toMessage(ClaimDailyRewardResponse).toMethod(this.onLoginRewardResponse);
            _local1.map(REALM_HERO_LEFT_MSG).toMessage(RealmHeroesResponse).toMethod(this.onRealmHeroesResponse);
        }

        private function onHatchPet(_arg1:HatchPetMessage):void{
            var _local2:HatchPetSignal = this.injector.getInstance(HatchPetSignal);
            var _local3:HatchPetVO = new HatchPetVO();
            _local3.itemType = _arg1.itemType;
            _local3.petSkin = _arg1.petSkin;
            _local3.petName = _arg1.petName;
            _local2.dispatch(_local3);
        }

        private function onDeletePet(_arg1:DeletePetMessage):void{
            var _local2:DeletePetSignal = this.injector.getInstance(DeletePetSignal);
            this.injector.getInstance(PetsModel).deletePet(_arg1.petID);
            _local2.dispatch(_arg1.petID);
        }

        private function onNewAbility(_arg1:NewAbilityMessage):void{
            var _local2:NewAbilitySignal = this.injector.getInstance(NewAbilitySignal);
            _local2.dispatch(_arg1.type);
        }

        private function onPetYardUpdate(_arg1:PetYard):void{
            var _local2:UpdatePetYardSignal = StaticInjectorContext.getInjector().getInstance(UpdatePetYardSignal);
            _local2.dispatch(_arg1.type);
        }

        private function onEvolvedPet(_arg1:EvolvedPetMessage):void{
            var _local2:EvolvedMessageHandler = this.injector.getInstance(EvolvedMessageHandler);
            _local2.handleMessage(_arg1);
        }

        private function onActivePetUpdate(_arg1:ActivePet):void{
            this.updateActivePet.dispatch(_arg1.instanceID);
            var _local2:String = (((_arg1.instanceID > 0)) ? this.petsModel.getPet(_arg1.instanceID).name : "");
            var _local3:String = (((_arg1.instanceID < 0)) ? TextKey.PET_NOT_FOLLOWING : TextKey.PET_FOLLOWING);
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, _local3, -1, -1, "", false, {petName:_local2}));
        }

        private function unmapMessages():void{
            var _local1:MessageMap = this.injector.getInstance(MessageMap);
            _local1.unmap(CREATE);
            _local1.unmap(PLAYERSHOOT);
            _local1.unmap(MOVE);
            _local1.unmap(PLAYERTEXT);
            _local1.unmap(UPDATEACK);
            _local1.unmap(INVSWAP);
            _local1.unmap(USEITEM);
            _local1.unmap(HELLO);
            _local1.unmap(INVDROP);
            _local1.unmap(PONG);
            _local1.unmap(LOAD);
            _local1.unmap(SETCONDITION);
            _local1.unmap(TELEPORT);
            _local1.unmap(USEPORTAL);
            _local1.unmap(BUY);
            _local1.unmap(PLAYERHIT);
            _local1.unmap(ENEMYHIT);
            _local1.unmap(AOEACK);
            _local1.unmap(SHOOTACK);
            _local1.unmap(OTHERHIT);
            _local1.unmap(SQUAREHIT);
            _local1.unmap(GOTOACK);
            _local1.unmap(GROUNDDAMAGE);
            _local1.unmap(CHOOSENAME);
            _local1.unmap(CREATEGUILD);
            _local1.unmap(GUILDREMOVE);
            _local1.unmap(GUILDINVITE);
            _local1.unmap(REQUESTTRADE);
            _local1.unmap(CHANGETRADE);
            _local1.unmap(ACCEPTTRADE);
            _local1.unmap(CANCELTRADE);
            _local1.unmap(CHECKCREDITS);
            _local1.unmap(ESCAPE);
            _local1.unmap(QUEST_ROOM_MSG);
            _local1.unmap(JOINGUILD);
            _local1.unmap(CHANGEGUILDRANK);
            _local1.unmap(EDITACCOUNTLIST);
            _local1.unmap(FAILURE);
            _local1.unmap(CREATE_SUCCESS);
            _local1.unmap(SERVERPLAYERSHOOT);
            _local1.unmap(DAMAGE);
            _local1.unmap(UPDATE);
            _local1.unmap(NOTIFICATION);
            _local1.unmap(GLOBAL_NOTIFICATION);
            _local1.unmap(NEWTICK);
            _local1.unmap(SHOWEFFECT);
            _local1.unmap(GOTO);
            _local1.unmap(INVRESULT);
            _local1.unmap(RECONNECT);
            _local1.unmap(PING);
            _local1.unmap(MAPINFO);
            _local1.unmap(PIC);
            _local1.unmap(DEATH);
            _local1.unmap(BUYRESULT);
            _local1.unmap(AOE);
            _local1.unmap(ACCOUNTLIST);
            _local1.unmap(QUESTOBJID);
            _local1.unmap(NAMERESULT);
            _local1.unmap(GUILDRESULT);
            _local1.unmap(ALLYSHOOT);
            _local1.unmap(ENEMYSHOOT);
            _local1.unmap(TRADEREQUESTED);
            _local1.unmap(TRADESTART);
            _local1.unmap(TRADECHANGED);
            _local1.unmap(TRADEDONE);
            _local1.unmap(TRADEACCEPTED);
            _local1.unmap(CLIENTSTAT);
            _local1.unmap(FILE);
            _local1.unmap(INVITEDTOGUILD);
            _local1.unmap(PLAYSOUND);
            _local1.unmap(REALM_HERO_LEFT_MSG);
        }

        override public function getNextDamage(_arg1:uint, _arg2:uint):uint{
            return (this.rand_.nextIntRange(_arg1, _arg2));
        }

        override public function enableJitterWatcher():void{
            if (jitterWatcher_ == null){
                jitterWatcher_ = new JitterWatcher();
            }
        }

        override public function disableJitterWatcher():void{
            if (jitterWatcher_ != null){
                jitterWatcher_ = null;
            }
        }

        private function create():void{
            var _local1:CharacterClass = this.classesModel.getSelected();
            var _local2:Create = (this.messages.require(CREATE) as Create);
            _local2.classType = _local1.id;
            _local2.skinType = _local1.skins.getSelectedSkin().id;
            serverConnection.sendMessage(_local2);
        }

        private function load():void{
            var _local1:Load = (this.messages.require(LOAD) as Load);
            _local1.charId_ = charId_;
            _local1.isFromArena_ = isFromArena_;
            serverConnection.sendMessage(_local1);
            if (isFromArena_){
                this.openDialog.dispatch(new BattleSummaryDialog());
            }
        }

        override public function playerShoot(_arg1:int, _arg2:Projectile):void{
            var _local3:PlayerShoot = (this.messages.require(PLAYERSHOOT) as PlayerShoot);
            _local3.time_ = _arg1;
            _local3.bulletId_ = _arg2.bulletId_;
            _local3.containerType_ = _arg2.containerType_;
            _local3.startingPos_.x_ = _arg2.x_;
            _local3.startingPos_.y_ = _arg2.y_;
            _local3.angle_ = _arg2.angle_;
            _local3.speedMult_ = _arg2.speedMul_;
            _local3.lifeMult_ = _arg2.lifeMul_;
            serverConnection.sendMessage(_local3);
        }

        override public function playerHit(_arg1:int, _arg2:int):void{
            var _local3:PlayerHit = (this.messages.require(PLAYERHIT) as PlayerHit);
            _local3.bulletId_ = _arg1;
            _local3.objectId_ = _arg2;
            serverConnection.sendMessage(_local3);
        }

        override public function enemyHit(_arg1:int, _arg2:int, _arg3:int, _arg4:Boolean):void{
            var _local5:EnemyHit = (this.messages.require(ENEMYHIT) as EnemyHit);
            _local5.time_ = _arg1;
            _local5.bulletId_ = _arg2;
            _local5.targetId_ = _arg3;
            _local5.kill_ = _arg4;
            serverConnection.sendMessage(_local5);
        }

        override public function otherHit(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void{
            var _local5:OtherHit = (this.messages.require(OTHERHIT) as OtherHit);
            _local5.time_ = _arg1;
            _local5.bulletId_ = _arg2;
            _local5.objectId_ = _arg3;
            _local5.targetId_ = _arg4;
            serverConnection.sendMessage(_local5);
        }

        override public function squareHit(_arg1:int, _arg2:int, _arg3:int):void{
            var _local4:SquareHit = (this.messages.require(SQUAREHIT) as SquareHit);
            _local4.time_ = _arg1;
            _local4.bulletId_ = _arg2;
            _local4.objectId_ = _arg3;
            serverConnection.sendMessage(_local4);
        }

        public function aoeAck(_arg1:int, _arg2:Number, _arg3:Number):void{
            var _local4:AoeAck = (this.messages.require(AOEACK) as AoeAck);
            _local4.time_ = _arg1;
            _local4.position_.x_ = _arg2;
            _local4.position_.y_ = _arg3;
            serverConnection.sendMessage(_local4);
        }

        override public function groundDamage(_arg1:int, _arg2:Number, _arg3:Number):void{
            var _local4:GroundDamage = (this.messages.require(GROUNDDAMAGE) as GroundDamage);
            _local4.time_ = _arg1;
            _local4.position_.x_ = _arg2;
            _local4.position_.y_ = _arg3;
            serverConnection.sendMessage(_local4);
        }

        public function shootAck(_arg1:int):void{
            var _local2:ShootAck = (this.messages.require(SHOOTACK) as ShootAck);
            _local2.time_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function playerText(_arg1:String):void{
            var _local2:PlayerText = (this.messages.require(PLAYERTEXT) as PlayerText);
            _local2.text_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function invSwap(_arg1:Player, _arg2:GameObject, _arg3:int, _arg4:int, _arg5:GameObject, _arg6:int, _arg7:int):Boolean{
            if (!gs_){
                return (false);
            }
            var _local8:InvSwap = (this.messages.require(INVSWAP) as InvSwap);
            _local8.time_ = gs_.lastUpdate_;
            _local8.position_.x_ = _arg1.x_;
            _local8.position_.y_ = _arg1.y_;
            _local8.slotObject1_.objectId_ = _arg2.objectId_;
            _local8.slotObject1_.slotId_ = _arg3;
            _local8.slotObject1_.objectType_ = _arg4;
            _local8.slotObject2_.objectId_ = _arg5.objectId_;
            _local8.slotObject2_.slotId_ = _arg6;
            _local8.slotObject2_.objectType_ = _arg7;
            serverConnection.sendMessage(_local8);
            var _local9:int = _arg2.equipment_[_arg3];
            _arg2.equipment_[_arg3] = _arg5.equipment_[_arg6];
            _arg5.equipment_[_arg6] = _local9;
            SoundEffectLibrary.play("inventory_move_item");
            return true;;
        }

        override public function invSwapPotion(_arg1:Player, _arg2:GameObject, _arg3:int, _arg4:int, _arg5:GameObject, _arg6:int, _arg7:int):Boolean{
            if (!gs_){
                return (false);
            }
            var _local8:InvSwap = (this.messages.require(INVSWAP) as InvSwap);
            _local8.time_ = gs_.lastUpdate_;
            _local8.position_.x_ = _arg1.x_;
            _local8.position_.y_ = _arg1.y_;
            _local8.slotObject1_.objectId_ = _arg2.objectId_;
            _local8.slotObject1_.slotId_ = _arg3;
            _local8.slotObject1_.objectType_ = _arg4;
            _local8.slotObject2_.objectId_ = _arg5.objectId_;
            _local8.slotObject2_.slotId_ = _arg6;
            _local8.slotObject2_.objectType_ = _arg7;
            _arg2.equipment_[_arg3] = ItemConstants.NO_ITEM;
            if (_arg4 == PotionInventoryModel.HEALTH_POTION_ID){
                _arg1.healthPotionCount_++;
            }
            else {
                if (_arg4 == PotionInventoryModel.MAGIC_POTION_ID){
                    _arg1.magicPotionCount_++;
                }
            }
            serverConnection.sendMessage(_local8);
            SoundEffectLibrary.play("inventory_move_item");
            return true;;
        }

        override public function invDrop(_arg1:GameObject, _arg2:int, _arg3:int):void{
            var _local4:InvDrop = (this.messages.require(INVDROP) as InvDrop);
            _local4.slotObject_.objectId_ = _arg1.objectId_;
            _local4.slotObject_.slotId_ = _arg2;
            _local4.slotObject_.objectType_ = _arg3;
            serverConnection.sendMessage(_local4);
            if (((!((_arg2 == PotionInventoryModel.HEALTH_POTION_SLOT))) && (!((_arg2 == PotionInventoryModel.MAGIC_POTION_SLOT))))){
                _arg1.equipment_[_arg2] = ItemConstants.NO_ITEM;
            }
        }

        override public function useItem(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:Number, _arg6:Number, _arg7:int):void{
            var _local8:UseItem = (this.messages.require(USEITEM) as UseItem);
            _local8.time_ = _arg1;
            _local8.slotObject_.objectId_ = _arg2;
            _local8.slotObject_.slotId_ = _arg3;
            _local8.slotObject_.objectType_ = _arg4;
            _local8.itemUsePos_.x_ = _arg5;
            _local8.itemUsePos_.y_ = _arg6;
            _local8.useType_ = _arg7;
            serverConnection.sendMessage(_local8);
        }

        override public function useItem_new(_arg1:GameObject, _arg2:int):Boolean{
            var _local4:XML;
            var _local3:int = _arg1.equipment_[_arg2];
            _local4 = ObjectLibrary.xmlLibrary_[_local3];
            if (((((_local4) && (!(_arg1.isPaused())))) && (((_local4.hasOwnProperty("Consumable")) || (_local4.hasOwnProperty("InvUse")))))){
                if (!this.validStatInc(_local3, _arg1)){
                    this.addTextLine.dispatch(ChatMessage.make("", (_local4.attribute("id") + " not consumed. Already at Max.")));
                    return (false);
                }
                if (isStatPotion(_local3)){
                    this.addTextLine.dispatch(ChatMessage.make("", (_local4.attribute("id") + " Consumed ++")));
                }
                this.applyUseItem(_arg1, _arg2, _local3, _local4);
                SoundEffectLibrary.play("use_potion");
                return true;;
            }
            SoundEffectLibrary.play("error");
            return (false);
        }

        private function validStatInc(_arg1:int, _arg2:GameObject):Boolean{
            var p:Player;
            var itemId:int = _arg1;
            var itemOwner:GameObject = _arg2;
            try {
                if ((itemOwner is Player)){
                    p = (itemOwner as Player);
                }
                else {
                    p = this.player;
                }
                if ((((((((((((((((((((((((itemId == 2591)) || ((itemId == 5465)))) || ((itemId == 9064)))) || ((itemId == 9729)))) && ((p.attackMax_ == (p.attack_ - p.attackBoost_))))) || ((((((((((itemId == 2592)) || ((itemId == 5466)))) || ((itemId == 9065)))) || ((itemId == 9727)))) && ((p.defenseMax_ == (p.defense_ - p.defenseBoost_))))))) || ((((((((((itemId == 2593)) || ((itemId == 5467)))) || ((itemId == 9066)))) || ((itemId == 9726)))) && ((p.speedMax_ == (p.speed_ - p.speedBoost_))))))) || ((((((((((itemId == 2612)) || ((itemId == 5468)))) || ((itemId == 9067)))) || ((itemId == 9724)))) && ((p.vitalityMax_ == (p.vitality_ - p.vitalityBoost_))))))) || ((((((((((itemId == 2613)) || ((itemId == 5469)))) || ((itemId == 9068)))) || ((itemId == 9725)))) && ((p.wisdomMax_ == (p.wisdom_ - p.wisdomBoost_))))))) || ((((((((((itemId == 2636)) || ((itemId == 5470)))) || ((itemId == 9069)))) || ((itemId == 0x2600)))) && ((p.dexterityMax_ == (p.dexterity_ - p.dexterityBoost_))))))) || ((((((((((itemId == 2793)) || ((itemId == 5471)))) || ((itemId == 9070)))) || ((itemId == 9731)))) && ((p.maxHPMax_ == (p.maxHP_ - p.maxHPBoost_))))))) || ((((((((((itemId == 2794)) || ((itemId == 5472)))) || ((itemId == 9071)))) || ((itemId == 9730)))) && ((p.maxMPMax_ == (p.maxMP_ - p.maxMPBoost_))))))){
                    return (false);
                }
            }
            catch(err:Error) {
                logger.error(("PROBLEM IN STAT INC " + err.getStackTrace()));
            }
            return true;;
        }

        private function applyUseItem(_arg1:GameObject, _arg2:int, _arg3:int, _arg4:XML):void{
            var _local5:UseItem = (this.messages.require(USEITEM) as UseItem);
            _local5.time_ = getTimer();
            _local5.slotObject_.objectId_ = _arg1.objectId_;
            _local5.slotObject_.slotId_ = _arg2;
            _local5.slotObject_.objectType_ = _arg3;
            _local5.itemUsePos_.x_ = 0;
            _local5.itemUsePos_.y_ = 0;
            serverConnection.sendMessage(_local5);
            if (_arg4.hasOwnProperty("Consumable")){
                _arg1.equipment_[_arg2] = -1;
            }
        }

        override public function setCondition(_arg1:uint, _arg2:Number):void{
            var _local3:SetCondition = (this.messages.require(SETCONDITION) as SetCondition);
            _local3.conditionEffect_ = _arg1;
            _local3.conditionDuration_ = _arg2;
            serverConnection.sendMessage(_local3);
        }

        public function move(_arg1:int, _arg2:uint, _arg3:Player):void{
            var _local8:int;
            var _local9:int;
            var _local4:Number = -1;
            var _local5:Number = -1;
            if (((_arg3) && (!(_arg3.isPaused())))){
                _local4 = _arg3.x_;
                _local5 = _arg3.y_;
            }
            var _local6:Move = (this.messages.require(MOVE) as Move);
            _local6.tickId_ = _arg1;
            _local6.time_ = gs_.lastUpdate_;
            _local6.serverRealTimeMSofLastNewTick_ = _arg2;
            _local6.newPosition_.x_ = _local4;
            _local6.newPosition_.y_ = _local5;
            var _local7:int = gs_.moveRecords_.lastClearTime_;
            _local6.records_.length = 0;
            if ((((_local7 >= 0)) && (((_local6.time_ - _local7) > 125)))){
                _local8 = Math.min(10, gs_.moveRecords_.records_.length);
                _local9 = 0;
                while (_local9 < _local8) {
                    if (gs_.moveRecords_.records_[_local9].time_ >= (_local6.time_ - 25)) break;
                    _local6.records_.push(gs_.moveRecords_.records_[_local9]);
                    _local9++;
                }
            }
            gs_.moveRecords_.clear(_local6.time_);
            serverConnection.sendMessage(_local6);
            ((_arg3) && (_arg3.onMove()));
        }

        override public function teleport(_arg1:int):void{
            var _local2:Teleport = (this.messages.require(TELEPORT) as Teleport);
            _local2.objectId_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function usePortal(_arg1:int):void{
            var _local2:UsePortal = (this.messages.require(USEPORTAL) as UsePortal);
            _local2.objectId_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function buy(_arg1:int, _arg2:int):void{
            var sObj:SellableObject;
            var converted:Boolean;
            var sellableObjectId:int = _arg1;
            var quantity:int = _arg2;
            if (outstandingBuy_ != null){
                return;
            }
            sObj = gs_.map.goDict_[sellableObjectId];
            if (sObj == null){
                return;
            }
            converted = false;
            if (sObj.currency_ == Currency.GOLD){
                converted = ((((gs_.model.getConverted()) || ((this.player.credits_ > 100)))) || ((sObj.price_ > this.player.credits_)));
            }
            if (sObj.soldObjectName() == TextKey.VAULT_CHEST){
                this.openDialog.dispatch(new PurchaseConfirmationDialog(function ():void{
                    buyConfirmation(sObj, converted, sellableObjectId, quantity);
                }));
            }
            else {
                this.buyConfirmation(sObj, converted, sellableObjectId, quantity);
            }
        }

        private function buyConfirmation(_arg1:SellableObject, _arg2:Boolean, _arg3:int, _arg4:int, _arg5:Boolean=false):void{
            outstandingBuy_ = new OutstandingBuy(_arg1.soldObjectInternalName(), _arg1.price_, _arg1.currency_, _arg2);
            var _local6:Buy = (this.messages.require(BUY) as Buy);
            _local6.objectId_ = _arg3;
            _local6.quantity_ = _arg4;
            serverConnection.sendMessage(_local6);
        }

        public function gotoAck(_arg1:int):void{
            var _local2:GotoAck = (this.messages.require(GOTOACK) as GotoAck);
            _local2.time_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function editAccountList(_arg1:int, _arg2:Boolean, _arg3:int):void{
            var _local4:EditAccountList = (this.messages.require(EDITACCOUNTLIST) as EditAccountList);
            _local4.accountListId_ = _arg1;
            _local4.add_ = _arg2;
            _local4.objectId_ = _arg3;
            serverConnection.sendMessage(_local4);
        }

        override public function chooseName(_arg1:String):void{
            var _local2:ChooseName = (this.messages.require(CHOOSENAME) as ChooseName);
            _local2.name_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function createGuild(_arg1:String):void{
            var _local2:CreateGuild = (this.messages.require(CREATEGUILD) as CreateGuild);
            _local2.name_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function guildRemove(_arg1:String):void{
            var _local2:GuildRemove = (this.messages.require(GUILDREMOVE) as GuildRemove);
            _local2.name_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function guildInvite(_arg1:String):void{
            var _local2:GuildInvite = (this.messages.require(GUILDINVITE) as GuildInvite);
            _local2.name_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function requestTrade(_arg1:String):void{
            var _local2:RequestTrade = (this.messages.require(REQUESTTRADE) as RequestTrade);
            _local2.name_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function changeTrade(_arg1:Vector.<Boolean>):void{
            var _local2:ChangeTrade = (this.messages.require(CHANGETRADE) as ChangeTrade);
            _local2.offer_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function acceptTrade(_arg1:Vector.<Boolean>, _arg2:Vector.<Boolean>):void{
            var _local3:AcceptTrade = (this.messages.require(ACCEPTTRADE) as AcceptTrade);
            _local3.myOffer_ = _arg1;
            _local3.yourOffer_ = _arg2;
            serverConnection.sendMessage(_local3);
        }

        override public function cancelTrade():void{
            serverConnection.sendMessage(this.messages.require(CANCELTRADE));
        }

        override public function checkCredits():void{
            serverConnection.sendMessage(this.messages.require(CHECKCREDITS));
        }

        override public function escape():void{
            if (this.playerId_ == -1){
                return;
            }
            if (((gs_.map) && ((gs_.map.name_ == "Arena")))){
                serverConnection.sendMessage(this.messages.require(ACCEPT_ARENA_DEATH));
            }
            else {
                this.isNexusing = true;
                serverConnection.sendMessage(this.messages.require(ESCAPE));
                this.showHideKeyUISignal.dispatch(false);
            }
        }

        override public function gotoQuestRoom():void{
            serverConnection.sendMessage(this.messages.require(QUEST_ROOM_MSG));
        }

        override public function joinGuild(_arg1:String):void{
            var _local2:JoinGuild = (this.messages.require(JOINGUILD) as JoinGuild);
            _local2.guildName_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        override public function changeGuildRank(_arg1:String, _arg2:int):void{
            var _local3:ChangeGuildRank = (this.messages.require(CHANGEGUILDRANK) as ChangeGuildRank);
            _local3.name_ = _arg1;
            _local3.guildRank_ = _arg2;
            serverConnection.sendMessage(_local3);
        }

        override public function changePetSkin(_arg1:int, _arg2:int, _arg3:int):void{
            var _local4:ChangePetSkin = (this.messages.require(PET_CHANGE_SKIN_MSG) as ChangePetSkin);
            _local4.petId = _arg1;
            _local4.skinType = _arg2;
            _local4.currency = _arg3;
            serverConnection.sendMessage(_local4);
        }

        private function rsaEncrypt(_arg1:String):String{
            var _local2:RSAKey = PEM.readRSAPublicKey(Parameters.RSA_PUBLIC_KEY);
            var _local3:ByteArray = new ByteArray();
            _local3.writeUTFBytes(_arg1);
            var _local4:ByteArray = new ByteArray();
            _local2.encrypt(_local3, _local4, _local3.length);
            return (Base64.encodeByteArray(_local4));
        }

        private function onConnected():void{
            isNexusing = false;

            var _local1:Account = StaticInjectorContext.getInjector().getInstance(Account);
            addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME, TextKey.CHAT_CONNECTED));

            var _local2:Hello = (messages.require(HELLO) as Hello);
            _local2.buildVersion_ = Parameters.CLIENT_VERSION;
            _local2.gameId_ = gameId_;
            _local2.guid_ = rsaEncrypt(_local1.getUserId());
            _local2.password_ = rsaEncrypt(_local1.getPassword());
            _local2.keyTime_ = keyTime_;
            _local2.key_.length = 0;
            ((!((key_ == null))) && (_local2.key_.writeBytes(key_)));
            _local2.mapJSON_ = (((mapJSON_ == null)) ? "" : mapJSON_);
            _local2.userToken = _local1.getToken();
            _local2.previousConnectionGuid = connectionGuid;
            serverConnection.sendMessage(_local2);
        }

        private function onCreateSuccess(_arg1:Socket):void {
            var objectId:int = _arg1.readInt();
            var charId:int = _arg1.readInt();

            this.playerId_ = objectId;
            charId_ = charId;
            gs_.initialize();
            createCharacter_ = false;
        }

        private function onDamage(_arg1:Socket):void{

            var targetId_ = _arg1.readInt();
            var len:int = _arg1.readUnsignedByte();
            var i:uint = 0;

            var effects_ = new Vector.<uint>();
            while (i < len) {
                effects_.push(_arg1.readUnsignedByte());
                i++;
            }

            var damageAmount_ = _arg1.readUnsignedShort();
            var kill_ = _arg1.readBoolean();
            var armorPierce_ = _arg1.readBoolean();
            var bulletId_ = _arg1.readUnsignedByte();
            var objectId_ = _arg1.readInt();

            var _local5:int;
            var _local6:Boolean;
            var _local2:AbstractMap = gs_.map;
            var _local3:Projectile;
            if ((((objectId_ >= 0)) && ((bulletId_ > 0)))){
                _local5 = Projectile.findObjId(objectId_, bulletId_);
                _local3 = (_local2.boDict_[_local5] as Projectile);
                if (((!((_local3 == null))) && (!(_local3.projProps_.multiHit_)))){
                    _local2.removeObj(_local5);
                }
            }
            var _local4:GameObject = _local2.goDict_[targetId_];
            if (_local4 != null){
                _local6 = (objectId_ == this.player.objectId_);
                _local4.damage(_local6, damageAmount_, effects_, kill_, _local3, armorPierce_);
            }
        }

        private function onServerPlayerShoot(_arg1:Socket):void{

            var bulletId = _arg1.readUnsignedByte();
            var ownerId = _arg1.readInt();
            var containerType = _arg1.readInt();
            var x = _arg1.readFloat();
            var y = _arg1.readFloat();
            var angle = _arg1.readFloat();
            var damage = _arg1.readShort();

            var _local2 = (ownerId == this.playerId_);
            var _local3:GameObject = gs_.map.goDict_[ownerId];
            if ((((_local3 == null)) || (_local3.dead_))){
                if (_local2){
                    this.shootAck(-1);
                }
                return;
            }

            if (((!((_local3.objectId_ == this.playerId_))) && (Parameters.data_.disableAllyShoot))){
                return;
            }

            var _local4:Projectile = (FreeList.newObject(Projectile) as Projectile);
            var _local5:Player = (_local3 as Player);
            if (_local5 != null){
                _local4.reset(containerType, 0, ownerId, bulletId, angle, gs_.lastUpdate_, _local5.projectileIdSetOverrideNew, _local5.projectileIdSetOverrideOld);
            }
            else {
                _local4.reset(containerType, 0, ownerId, bulletId, angle, gs_.lastUpdate_);
            }

            _local4.setDamage(damage);
            gs_.map.addObj(_local4, x, y);
            if (_local2){
                this.shootAck(gs_.lastUpdate_);
            }
        }

        private function onAllyShoot(_arg1:AllyShoot):void{
            var _local5:Number;
            var _local6:Number;
            var _local2:GameObject = gs_.map.goDict_[_arg1.ownerId_];
            if ((((_local2 == null)) || (_local2.dead_))){
                return;
            }
            if (Parameters.data_.disableAllyShoot == 1){
                return;
            }
            _local2.setAttack(_arg1.containerType_, _arg1.angle_);
            if (Parameters.data_.disableAllyShoot == 2){
                return;
            }
            var _local3:Projectile = (FreeList.newObject(Projectile) as Projectile);
            var _local4:Player = (_local2 as Player);
            if (_local4 != null){
                _local5 = _local4.projectileLifeMul_;
                _local6 = _local4.projectileSpeedMult_;
                if (!_arg1.bard_){
                    _local5 = 1;
                    _local6 = 1;
                }
                _local3.reset(_arg1.containerType_, 0, _arg1.ownerId_, _arg1.bulletId_, _arg1.angle_, gs_.lastUpdate_, _local4.projectileIdSetOverrideNew, _local4.projectileIdSetOverrideOld, _local5, _local6);
            }
            else {
                _local3.reset(_arg1.containerType_, 0, _arg1.ownerId_, _arg1.bulletId_, _arg1.angle_, gs_.lastUpdate_);
            }
            gs_.map.addObj(_local3, _local2.x_, _local2.y_);
        }

        private function onReskinUnlock(_arg1:ReskinUnlock):void{
            var _local2:String;
            var _local3:CharacterSkin;
            var _local4:PetsModel;
            if (_arg1.isPetSkin == 0){
                for (_local2 in this.model.player.lockedSlot) {
                    if (this.model.player.lockedSlot[_local2] == _arg1.skinID){
                        this.model.player.lockedSlot[_local2] = 0;
                    }
                }
                _local3 = this.classesModel.getCharacterClass(this.model.player.objectType_).skins.getSkin(_arg1.skinID);
                _local3.setState(CharacterSkinState.OWNED);
            }
            else {
                _local4 = StaticInjectorContext.getInjector().getInstance(PetsModel);
                _local4.unlockSkin(_arg1.skinID);
            }
        }

        private function onEnemyShoot(_arg1:EnemyShoot):void{
            var _local4:Projectile;
            var _local5:Number;
            var _local2:GameObject = gs_.map.goDict_[_arg1.ownerId_];
            if ((((_local2 == null)) || (_local2.dead_))){
                this.shootAck(-1);
                return;
            }
            var _local3:int;
            while (_local3 < _arg1.numShots_) {
                _local4 = (FreeList.newObject(Projectile) as Projectile);
                _local5 = (_arg1.angle_ + (_arg1.angleInc_ * _local3));
                _local4.reset(_local2.objectType_, _arg1.bulletType_, _arg1.ownerId_, ((_arg1.bulletId_ + _local3) % 0x0100), _local5, gs_.lastUpdate_);
                _local4.setDamage(_arg1.damage_);
                gs_.map.addObj(_local4, _arg1.startingPos_.x_, _arg1.startingPos_.y_);
                _local3++;
            }
            this.shootAck(gs_.lastUpdate_);
            _local2.setAttack(_local2.objectType_, (_arg1.angle_ + (_arg1.angleInc_ * ((_arg1.numShots_ - 1) / 2))));
        }

        private function onTradeRequested(_arg1:TradeRequested):void{
            if (!Parameters.data_.chatTrade){
                return;
            }
            if (((Parameters.data_.tradeWithFriends) && (!(this.socialModel.isMyFriend(_arg1.name_))))){
                return;
            }
            if (Parameters.data_.showTradePopup){
                gs_.hudView.interactPanel.setOverride(new TradeRequestPanel(gs_, _arg1.name_));
            }
            this.addTextLine.dispatch(ChatMessage.make("", ((((_arg1.name_ + " wants to ") + 'trade with you.  Type "/trade ') + _arg1.name_) + '" to trade.')));
        }

        private function onTradeStart(_arg1:TradeStart):void{
            gs_.hudView.startTrade(gs_, _arg1);
        }

        private function onTradeChanged(_arg1:TradeChanged):void{
            gs_.hudView.tradeChanged(_arg1);
        }

        private function onTradeDone(_arg1:TradeDone):void{
            var _local3:Object;
            var _local4:Object;
            gs_.hudView.tradeDone();
            var _local2 = "";
            try {
                _local4 = JSON.parse(_arg1.description_);
                _local2 = _local4.key;
                _local3 = _local4.tokens;
            }
            catch(e:Error) {
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, _local2, -1, -1, "", false, _local3));
        }

        private function onTradeAccepted(_arg1:TradeAccepted):void{
            gs_.hudView.tradeAccepted(_arg1);
        }

        private function addObject(_arg1:ObjectData):void{
            var _local2:AbstractMap = gs_.map;
            var _local3:GameObject = ObjectLibrary.getObjectFromType(_arg1.objectType_);
            if (_local3 == null || (_arg1.status_.objectId_ == this.playerId_ && player)){
                return;
            }

            var _local4:ObjectStatusData = _arg1.status_;
            _local3.setObjectId(_local4.objectId_);
            _local2.addObj(_local3, _local4.pos_.x_, _local4.pos_.y_);
            if ((_local3 is Player)){
                this.handleNewPlayer((_local3 as Player), _local2);
            }
            this.processObjectStatus(_local4, 0, -1);
            if (((((_local3.props_.static_) && (_local3.props_.occupySquare_))) && (!(_local3.props_.noMiniMap_)))){
                this.updateGameObjectTileSignal.dispatch(new UpdateGameObjectTileVO(_local3.x_, _local3.y_, _local3));
            }
        }

        private function handleNewPlayer(_arg1:Player, _arg2:AbstractMap):void{
            this.setPlayerSkinTemplate(_arg1, 0);
            if (_arg1.objectId_ == this.playerId_){
                this.player = _arg1;
                this.model.player = _arg1;
                _arg2.player_ = _arg1;
                gs_.setFocus(_arg1);
                this.setGameFocus.dispatch(this.playerId_.toString());
            }
        }

        private function onUpdate(_arg1:Socket):void{

            var _local2:Message = this.messages.require(UPDATEACK);
            serverConnection.sendMessage(_local2);

            var i:int = 0;
            var len:int = _arg1.readShort();
            while (i < len) {

                var x:int = _arg1.readShort();
                var y:int = _arg1.readShort();
                var type:uint = _arg1.readUnsignedShort();

                gs_.map.setGroundTile(x, y, type);
                this.updateGroundTileSignal.dispatch(new UpdateGroundTileVO(x, y, type));
                i++;
            }

            i = 0;
            len = _arg1.readShort();
            while (i < len) {
                var objectData:ObjectData = new ObjectData();
                objectData.parseFromInput(_arg1);
                addObject(objectData);
                i++;
            }

            i = 0;
            len = _arg1.readShort();
            while (i < len) {
                var objectId:int = _arg1.readInt();
                gs_.map.removeObj(objectId);
                i++;
            }
        }

        private function onNotification(_arg1:Socket):void{

            var objectId_ = _arg1.readInt();
            var message = _arg1.readUTF();
            var color_ = _arg1.readInt();

            var _local3:LineBuilder;
            var _local2:GameObject = gs_.map.goDict_[objectId_];
            if (_local2 != null){
                _local3 = LineBuilder.fromJSON(message);
                if (_local2 == this.player){
                    if (_local3.key == "server.quest_complete"){
                        gs_.map.quest_.completed();
                    }
                    this.makeNotification(_local3, _local2, color_, 1000);
                }
                else {
                    if (((_local2.props_.isEnemy_) || (!(Parameters.data_.noAllyNotifications)))){
                        this.makeNotification(_local3, _local2, color_, 1000);
                    }
                }
            }
        }

        private function makeNotification(_arg1:LineBuilder, _arg2:GameObject, _arg3:uint, _arg4:int):void{
            var _local5:CharacterStatusText = new CharacterStatusText(_arg2, _arg3, _arg4);
            _local5.setStringBuilder(_arg1);
            gs_.map.mapOverlay_.addStatusText(_local5);
        }

        private function onGlobalNotification(_arg1:Socket):void {
            var type = _arg1.readInt();
            var text = _arg1.readUTF();

            switch (text){
                case "yellow":
                    ShowKeySignal.instance.dispatch(Key.YELLOW);
                    return;
                case "red":
                    ShowKeySignal.instance.dispatch(Key.RED);
                    return;
                case "green":
                    ShowKeySignal.instance.dispatch(Key.GREEN);
                    return;
                case "purple":
                    ShowKeySignal.instance.dispatch(Key.PURPLE);
                    return;
                case "showKeyUI":
                    this.showHideKeyUISignal.dispatch(false);
                    return;
                case "giftChestOccupied":
                    this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_GIFT);
                    return;
                case "giftChestEmpty":
                    this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_NO_GIFT);
                    return;
                case "beginnersPackage":
                    return;
            }
        }

        private function onNewTick(_arg1:Socket):void{

            var tickId_ = _arg1.readInt();
            var tickTime_ = _arg1.readInt();
            var serverRealTimeMS_ = _arg1.readUnsignedInt();
            var serverLastRTTMS_ = _arg1.readUnsignedShort();
            var statuses_ = new Vector.<ObjectStatusData>();

            var i:int = 0;
            var len:int = _arg1.readShort();
            while (i < len) {
                statuses_[i] = new ObjectStatusData();
                statuses_[i].parseFromInput(_arg1);
                i++;
            }

            var _local2:ObjectStatusData;
            if (jitterWatcher_ != null){
                jitterWatcher_.record();
            }
            lastServerRealTimeMS_ = serverRealTimeMS_;
            this.move(tickId_, lastServerRealTimeMS_, this.player);
            for each (_local2 in statuses_) {
                this.processObjectStatus(_local2, tickTime_, tickId_);
            }
            lastTickId_ = tickId_;
        }

        private function canShowEffect(_arg1:GameObject):Boolean{
            if (_arg1 != null){
                return true;;
            }
            var _local2 = (_arg1.objectId_ == this.playerId_);
            if (((((!(_local2)) && (_arg1.props_.isPlayer_))) && (Parameters.data_.disableAllyShoot))){
                return (false);
            }
            return true;;
        }


        private static const EFFECT_BIT_COLOR:int = (1 << 0);
        private static const EFFECT_BIT_POS1_X:int = (1 << 1);
        private static const EFFECT_BIT_POS1_Y:int = (1 << 2);
        private static const EFFECT_BIT_POS2_X:int = (1 << 3);
        private static const EFFECT_BIT_POS2_Y:int = (1 << 4);
        private static const EFFECT_BIT_POS1:int = (EFFECT_BIT_POS1_X | EFFECT_BIT_POS1_Y);
        private static const EFFECT_BIT_POS2:int = (EFFECT_BIT_POS2_X | EFFECT_BIT_POS2_Y);
        private static const EFFECT_BIT_DURATION:int = (1 << 5);
        private static const EFFECT_BIT_ID:int = (1 << 6);
        public static const UNKNOWN_EFFECT_TYPE:int = 0;
        public static const HEAL_EFFECT_TYPE:int = 1;
        public static const TELEPORT_EFFECT_TYPE:int = 2;
        public static const STREAM_EFFECT_TYPE:int = 3;
        public static const THROW_EFFECT_TYPE:int = 4;
        public static const NOVA_EFFECT_TYPE:int = 5;
        public static const POISON_EFFECT_TYPE:int = 6;
        public static const LINE_EFFECT_TYPE:int = 7;
        public static const BURST_EFFECT_TYPE:int = 8;
        public static const FLOW_EFFECT_TYPE:int = 9;
        public static const RING_EFFECT_TYPE:int = 10;
        public static const LIGHTNING_EFFECT_TYPE:int = 11;
        public static const COLLAPSE_EFFECT_TYPE:int = 12;
        public static const CONEBLAST_EFFECT_TYPE:int = 13;
        public static const JITTER_EFFECT_TYPE:int = 14;
        public static const FLASH_EFFECT_TYPE:int = 15;
        public static const THROW_PROJECTILE_EFFECT_TYPE:int = 16;
        public static const SHOCKER_EFFECT_TYPE:int = 17;
        public static const SHOCKEE_EFFECT_TYPE:int = 18;
        public static const RISING_FURY_EFFECT_TYPE:int = 19;
        public static const NOVA_NO_AOE_EFFECT_TYPE:int = 20;
        public static const INSPIRED_EFFECT_TYPE:int = 21;
        public static const HOLY_BEAM_EFFECT_TYPE:int = 22;
        public static const CIRCLE_TELEGRAPH_EFFECT_TYPE:int = 23;
        public static const CHAOS_BEAM_EFFECT_TYPE:int = 24;
        public static const TELEPORT_MONSTER_EFFECT_TYPE:int = 25;
        public static const METEOR_EFFECT_TYPE:int = 26;
        public static const GILDED_BUFF_EFFECT_TYPE:int = 27;
        public static const JADE_BUFF_EFFECT_TYPE:int = 28;
        public static const CHAOS_BUFF_EFFECT_TYPE:int = 29;
        public static const THUNDER_BUFF_EFFECT_TYPE:int = 30;
        public static const STATUS_FLASH_EFFECT_TYPE:int = 31;
        public static const FIRE_ORB_BUFF_EFFECT_TYPE:int = 32;

        private function onShowEffect(_arg1:Socket):void{

            var effectType_ = _arg1.readUnsignedByte();
            var bits:uint = _arg1.readUnsignedByte();
            var pos1_ = new WorldPosData();
            var pos2_ = new WorldPosData();
            var targetObjectId_:int = 0;
            var color_:uint = 0xFFFFFFFF;
            var duration_:Number = 1;

            if ((bits & EFFECT_BIT_ID)){
                targetObjectId_ = CompressedInt.Read(_arg1);
            }

            if ((bits & EFFECT_BIT_POS1_X)){
                pos1_.x_ = _arg1.readFloat();
            }

            if ((bits & EFFECT_BIT_POS1_Y)){
                pos1_.y_ = _arg1.readFloat();
            }

            if ((bits & EFFECT_BIT_POS2_X)){
                pos2_.x_ = _arg1.readFloat();
            }

            if ((bits & EFFECT_BIT_POS2_Y)){
                pos2_.y_ = _arg1.readFloat();
            }

            if ((bits & EFFECT_BIT_COLOR)){
                color_ = _arg1.readInt();
            }

            if ((bits & EFFECT_BIT_DURATION)){
                duration_ = _arg1.readFloat();
            }

            var _local3:GameObject;
            var _local4:ParticleEffect;
            var _local5:Point;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local11:uint;
            var _local12:uint;
            var _local13:uint;
            var _local14:uint;
            var _local15:uint;
            var _local16:uint;
            var _local17:uint;
            var _local18:uint;
            var _local19:uint;
            if (((Parameters.data_.noParticlesMaster) && ((((((((((((((((((effectType_ == ShowEffect.HEAL_EFFECT_TYPE)) || ((effectType_ == ShowEffect.TELEPORT_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.STREAM_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.POISON_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.LINE_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.FLOW_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.COLLAPSE_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.CONEBLAST_EFFECT_TYPE)))) || ((effectType_ == ShowEffect.NOVA_NO_AOE_EFFECT_TYPE)))))){
                return;
            }
            var _local2:AbstractMap = gs_.map;
            switch (effectType_){
                case ShowEffect.HEAL_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local2.addObj(new HealEffect(_local3, color_), _local3.x_, _local3.y_);
                    return;
                case ShowEffect.TELEPORT_EFFECT_TYPE:
                    _local2.addObj(new TeleportEffect(), pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.STREAM_EFFECT_TYPE:
                    _local4 = new StreamEffect(pos1_, pos2_, color_);
                    _local2.addObj(_local4, pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.THROW_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    _local5 = (((_local3)!=null) ? new Point(_local3.x_, _local3.y_) : pos2_.toPoint());
                    if (((!((_local3 == null))) && (!(this.canShowEffect(_local3))))) break;
                    _local4 = new ThrowEffect(_local5, pos1_.toPoint(), color_, (duration_ * 1000));
                    _local2.addObj(_local4, _local5.x, _local5.y);
                    return;
                case ShowEffect.NOVA_EFFECT_TYPE:
                case ShowEffect.NOVA_NO_AOE_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new NovaEffect(_local3, pos1_.x_, color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.POISON_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new PoisonEffect(_local3, color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.LINE_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new LineEffect(_local3, pos1_, color_);
                    _local2.addObj(_local4, pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.BURST_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new BurstEffect(_local3, pos1_, pos2_, color_);
                    _local2.addObj(_local4, pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.FLOW_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new FlowEffect(pos1_, _local3, color_);
                    _local2.addObj(_local4, pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.RING_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new RingEffect(_local3, pos1_.x_, color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.LIGHTNING_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new LightningEffect(_local3, pos1_, color_, pos2_.x_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.COLLAPSE_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new CollapseEffect(_local3, pos1_, pos2_, color_);
                    _local2.addObj(_local4, pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.CONEBLAST_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new ConeBlastEffect(_local3, pos1_, pos2_.x_, color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.JITTER_EFFECT_TYPE:
                    gs_.camera_.startJitter();
                    return;
                case ShowEffect.FLASH_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local3.flash_ = new FlashDescription(getTimer(), color_, pos1_.x_, pos1_.y_);
                    return;
                case ShowEffect.THROW_PROJECTILE_EFFECT_TYPE:
                    _local5 = pos1_.toPoint();
                    if (((!((_local3 == null))) && (!(this.canShowEffect(_local3))))) break;
                    _local4 = new ThrowProjectileEffect(color_, pos2_.toPoint(), pos1_.toPoint(), (duration_ * 1000));
                    _local2.addObj(_local4, _local5.x, _local5.y);
                    return;
                case ShowEffect.INSPIRED_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    if (((_local3) && (_local3.spritesProjectEffect))){
                        _local3.spritesProjectEffect.destroy();
                    }
                    _local2.addObj(new InspireEffect(_local3, 0xFFBA00, 5), _local3.x_, _local3.y_);
                    _local3.flash_ = new FlashDescription(getTimer(), color_, pos2_.x_, pos2_.y_);
                    _local4 = new SpritesProjectEffect(_local3, pos1_.x_);
                    _local3.spritesProjectEffect = SpritesProjectEffect(_local4);
                    gs_.map.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.SHOCKER_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    if (((_local3) && (_local3.shockEffect))){
                        _local3.shockEffect.destroy();
                    }
                    _local4 = new ShockerEffect(_local3);
                    _local3.shockEffect = ShockerEffect(_local4);
                    gs_.map.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.SHOCKEE_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local4 = new ShockeeEffect(_local3);
                    gs_.map.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.RISING_FURY_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local6 = (pos1_.x_ * 1000);
                    _local4 = new RisingFuryEffect(_local3, _local6);
                    gs_.map.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffect.HOLY_BEAM_EFFECT_TYPE:
                case ShowEffect.CIRCLE_TELEGRAPH_EFFECT_TYPE:
                case ShowEffect.CHAOS_BEAM_EFFECT_TYPE:
                case ShowEffect.TELEPORT_MONSTER_EFFECT_TYPE:
                case ShowEffect.METEOR_EFFECT_TYPE:
                    return;
                case ShowEffect.GILDED_BUFF_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local7 = 16768115;
                    _local8 = 0xFF9A00;
                    _local9 = 0xA66400;
                    _local3.flash_ = new FlashDescription(getTimer(), _local7, 0.5, 9);
                    _local2.addObj(new GildedEffect(_local3, _local7, _local8, _local9, 2, 4500), _local3.x_, _local3.y_);
                    return;
                case ShowEffect.JADE_BUFF_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local10 = 4736621;
                    _local11 = 4031656;
                    _local12 = 4640207;
                    _local3.flash_ = new FlashDescription(getTimer(), _local10, 0.5, 9);
                    _local2.addObj(new GildedEffect(_local3, _local10, _local11, _local12, 2, 4500), _local3.x_, _local3.y_);
                    return;
                case ShowEffect.CHAOS_BUFF_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local13 = 3675232;
                    _local14 = 11673446;
                    _local15 = 16659566;
                    _local3.flash_ = new FlashDescription(getTimer(), _local13, 0.5, 9);
                    _local2.addObj(new GildedEffect(_local3, _local13, _local14, _local15, 2, 4500), _local3.x_, _local3.y_);
                    return;
                case ShowEffect.THUNDER_BUFF_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local16 = 16768115;
                    _local3.flash_ = new FlashDescription(getTimer(), _local16, 0.25, 1);
                    _local2.addObj(new ThunderEffect(_local3), _local3.x_, _local3.y_);
                    return;
                case ShowEffect.STATUS_FLASH_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local3.statusFlash_ = new StatusFlashDescription(getTimer(), color_, pos1_.x_);
                    return;
                case ShowEffect.FIRE_ORB_BUFF_EFFECT_TYPE:
                    _local3 = _local2.goDict_[targetObjectId_];
                    if ((((_local3 == null)) || (!(this.canShowEffect(_local3))))) break;
                    _local17 = 11673446;
                    _local18 = 3675232;
                    _local19 = 16659566;
                    _local3.flash_ = new FlashDescription(getTimer(), _local17, 0.25, 1);
                    _local2.addObj(new OrbEffect(_local3, _local17, _local18, _local19, 1.5, 2500, pos1_.toPoint()), pos1_.x_, pos1_.y_);
                    return;
            }
        }

        private function onGoto(_arg1:Socket):void{
            var objectId:int = _arg1.readInt();
            var x:Number = _arg1.readFloat();
            var y:Number = _arg1.readFloat();

            gotoAck(gs_.lastUpdate_);
            var _local2:GameObject = gs_.map.goDict_[objectId];
            if (_local2 == null){
                return;
            }
            _local2.onGoto(x, y, gs_.lastUpdate_);
        }

        private function updateGameObject(_arg1:GameObject, _arg2:Vector.<StatData>, _arg3:Boolean):void{
            var _local7:StatData;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local4:Player = (_arg1 as Player);
            var _local5:Merchant = (_arg1 as Merchant);
            var _local6:Pet = (_arg1 as Pet);
            if (_local6){
                this.petUpdater.updatePet(_local6, _arg2);
                if (gs_.map.isPetYard){
                    this.petUpdater.updatePetVOs(_local6, _arg2);
                }
                return;
            }
            for each (_local7 in _arg2) {
                _local8 = _local7.statValue_;
                switch (_local7.statType_){
                    case StatData.MAX_HP_STAT:
                        _arg1.maxHP_ = _local8;
                        break;
                    case StatData.HP_STAT:
                        _arg1.hp_ = _local8;
                        if (((((((_arg1.dead_) && ((_local8 > 1)))) && (_arg1.props_.isEnemy_))) && ((++_arg1.deadCounter_ >= 2)))){
                            _arg1.dead_ = false;
                        }
                        break;
                    case StatData.SIZE_STAT:
                        _arg1.size_ = _local8;
                        break;
                    case StatData.MAX_MP_STAT:
                        _local4.maxMP_ = _local8;
                        break;
                    case StatData.MP_STAT:
                        _local4.mp_ = _local8;
                        if (_local8 == 0){
                            _local4.mpZeroed_ = true;
                        }
                        break;
                    case StatData.NEXT_LEVEL_EXP_STAT:
                        _local4.nextLevelExp_ = _local8;
                        break;
                    case StatData.EXP_STAT:
                        _local4.exp_ = _local8;
                        break;
                    case StatData.LEVEL_STAT:
                        _arg1.level_ = _local8;
                        if (((!((_local4 == null))) && ((_arg1.objectId_ == this.playerId_)))){
                            this.realmQuestLevelSignal.dispatch(_local8);
                        }
                        break;
                    case StatData.ATTACK_STAT:
                        _local4.attack_ = _local8;
                        break;
                    case StatData.DEFENSE_STAT:
                        _arg1.defense_ = _local8;
                        break;
                    case StatData.SPEED_STAT:
                        _local4.speed_ = _local8;
                        break;
                    case StatData.DEXTERITY_STAT:
                        _local4.dexterity_ = _local8;
                        break;
                    case StatData.VITALITY_STAT:
                        _local4.vitality_ = _local8;
                        break;
                    case StatData.WISDOM_STAT:
                        _local4.wisdom_ = _local8;
                        break;
                    case StatData.CONDITION_STAT:
                        _arg1.condition_[ConditionEffect.CE_FIRST_BATCH] = _local8;
                        break;
                    case StatData.INVENTORY_0_STAT:
                    case StatData.INVENTORY_1_STAT:
                    case StatData.INVENTORY_2_STAT:
                    case StatData.INVENTORY_3_STAT:
                    case StatData.INVENTORY_4_STAT:
                    case StatData.INVENTORY_5_STAT:
                    case StatData.INVENTORY_6_STAT:
                    case StatData.INVENTORY_7_STAT:
                    case StatData.INVENTORY_8_STAT:
                    case StatData.INVENTORY_9_STAT:
                    case StatData.INVENTORY_10_STAT:
                    case StatData.INVENTORY_11_STAT:
                        _local9 = (_local7.statType_ - StatData.INVENTORY_0_STAT);
                        if (_local8 != -1){
                            _arg1.lockedSlot[_local9] = 0;
                        }
                        _arg1.equipment_[_local9] = _local8;
                        break;
                    case StatData.NUM_STARS_STAT:
                        _local4.numStars_ = _local8;
                        break;
                    case StatData.NAME_STAT:
                        if (_arg1.name_ != _local7.strStatValue_){
                            _arg1.name_ = _local7.strStatValue_;
                            _arg1.nameBitmapData_ = null;
                        }
                        break;
                    case StatData.TEX1_STAT:
                        (((_local8 >= 0)) && (_arg1.setTex1(_local8)));
                        break;
                    case StatData.TEX2_STAT:
                        (((_local8 >= 0)) && (_arg1.setTex2(_local8)));
                        break;
                    case StatData.MERCHANDISE_TYPE_STAT:
                        _local5.setMerchandiseType(_local8);
                        break;
                    case StatData.CREDITS_STAT:
                        _local4.setCredits(_local8);
                        break;
                    case StatData.MERCHANDISE_PRICE_STAT:
                        (_arg1 as SellableObject).setPrice(_local8);
                        break;
                    case StatData.ACTIVE_STAT:
                        (_arg1 as Portal).active_ = !((_local8 == 0));
                        break;
                    case StatData.ACCOUNT_ID_STAT:
                        _local4.accountId_ = _local7.strStatValue_;
                        break;
                    case StatData.FAME_STAT:
                        _local4.setFame(_local8);
                        break;
                    case StatData.FORTUNE_TOKEN_STAT:
                        _local4.setTokens(_local8);
                        break;
                    case StatData.SUPPORTER_POINTS_STAT:
                        if (_local4 != null){
                            _local4.supporterPoints = _local8;
                            _local4.clearTextureCache();
                            if (_local4.objectId_ == this.playerId_){
                                StaticInjectorContext.getInjector().getInstance(SupporterCampaignModel).updatePoints(_local8);
                            }
                        }
                        break;
                    case StatData.SUPPORTER_STAT:
                        if (_local4 != null){
                            _local4.setSupporterFlag(_local8);
                        }
                        break;
                    case StatData.MERCHANDISE_CURRENCY_STAT:
                        (_arg1 as SellableObject).setCurrency(_local8);
                        break;
                    case StatData.CONNECT_STAT:
                        _arg1.connectType_ = _local8;
                        break;
                    case StatData.MERCHANDISE_COUNT_STAT:
                        _local5.count_ = _local8;
                        _local5.untilNextMessage_ = 0;
                        break;
                    case StatData.MERCHANDISE_MINS_LEFT_STAT:
                        _local5.minsLeft_ = _local8;
                        _local5.untilNextMessage_ = 0;
                        break;
                    case StatData.MERCHANDISE_DISCOUNT_STAT:
                        _local5.discount_ = _local8;
                        _local5.untilNextMessage_ = 0;
                        break;
                    case StatData.MERCHANDISE_RANK_REQ_STAT:
                        (_arg1 as SellableObject).setRankReq(_local8);
                        break;
                    case StatData.MAX_HP_BOOST_STAT:
                        _local4.maxHPBoost_ = _local8;
                        break;
                    case StatData.MAX_MP_BOOST_STAT:
                        _local4.maxMPBoost_ = _local8;
                        break;
                    case StatData.ATTACK_BOOST_STAT:
                        _local4.attackBoost_ = _local8;
                        break;
                    case StatData.DEFENSE_BOOST_STAT:
                        _local4.defenseBoost_ = _local8;
                        break;
                    case StatData.SPEED_BOOST_STAT:
                        _local4.speedBoost_ = _local8;
                        break;
                    case StatData.VITALITY_BOOST_STAT:
                        _local4.vitalityBoost_ = _local8;
                        break;
                    case StatData.WISDOM_BOOST_STAT:
                        _local4.wisdomBoost_ = _local8;
                        break;
                    case StatData.DEXTERITY_BOOST_STAT:
                        _local4.dexterityBoost_ = _local8;
                        break;
                    case StatData.OWNER_ACCOUNT_ID_STAT:
                        (_arg1 as Container).setOwnerId(_local7.strStatValue_);
                        break;
                    case StatData.RANK_REQUIRED_STAT:
                        (_arg1 as NameChanger).setRankRequired(_local8);
                        break;
                    case StatData.NAME_CHOSEN_STAT:
                        _local4.nameChosen_ = !((_local8 == 0));
                        _arg1.nameBitmapData_ = null;
                        break;
                    case StatData.CURR_FAME_STAT:
                        _local4.currFame_ = _local8;
                        break;
                    case StatData.NEXT_CLASS_QUEST_FAME_STAT:
                        _local4.nextClassQuestFame_ = _local8;
                        break;
                    case StatData.LEGENDARY_RANK_STAT:
                        _local4.legendaryRank_ = _local8;
                        break;
                    case StatData.SINK_LEVEL_STAT:
                        if (!_arg3){
                            _local4.sinkLevel_ = _local8;
                        }
                        break;
                    case StatData.ALT_TEXTURE_STAT:
                        _arg1.setAltTexture(_local8);
                        break;
                    case StatData.GUILD_NAME_STAT:
                        _local4.setGuildName(_local7.strStatValue_);
                        break;
                    case StatData.GUILD_RANK_STAT:
                        _local4.guildRank_ = _local8;
                        break;
                    case StatData.BREATH_STAT:
                        _local4.breath_ = _local8;
                        break;
                    case StatData.XP_BOOSTED_STAT:
                        _local4.xpBoost_ = _local8;
                        break;
                    case StatData.XP_TIMER_STAT:
                        _local4.xpTimer = (_local8 * TO_MILLISECONDS);
                        break;
                    case StatData.LD_TIMER_STAT:
                        _local4.dropBoost = (_local8 * TO_MILLISECONDS);
                        break;
                    case StatData.LT_TIMER_STAT:
                        _local4.tierBoost = (_local8 * TO_MILLISECONDS);
                        break;
                    case StatData.HEALTH_POTION_STACK_STAT:
                        _local4.healthPotionCount_ = _local8;
                        break;
                    case StatData.MAGIC_POTION_STACK_STAT:
                        _local4.magicPotionCount_ = _local8;
                        break;
                    case StatData.PROJECTILE_LIFE_MULT:
                        _local4.projectileLifeMul_ = (_local8 / 1000);
                        break;
                    case StatData.PROJECTILE_SPEED_MULT:
                        _local4.projectileSpeedMult_ = (_local8 / 1000);
                        break;
                    case StatData.TEXTURE_STAT:
                        if (_local4 != null){
                            ((((!((_local4.skinId == _local8))) && ((_local8 >= 0)))) && (this.setPlayerSkinTemplate(_local4, _local8)));
                        }
                        else {
                            if ((((_arg1.objectType_ == 1813)) && ((_local8 > 0)))){
                                _arg1.setTexture(_local8);
                            }
                        }
                        break;
                    case StatData.HASBACKPACK_STAT:
                        (_arg1 as Player).hasBackpack_ = Boolean(_local8);
                        if (_arg3){
                            this.updateBackpackTab.dispatch(Boolean(_local8));
                        }
                        break;
                    case StatData.BACKPACK_0_STAT:
                    case StatData.BACKPACK_1_STAT:
                    case StatData.BACKPACK_2_STAT:
                    case StatData.BACKPACK_3_STAT:
                    case StatData.BACKPACK_4_STAT:
                    case StatData.BACKPACK_5_STAT:
                    case StatData.BACKPACK_6_STAT:
                    case StatData.BACKPACK_7_STAT:
                        _local10 = (((_local7.statType_ - StatData.BACKPACK_0_STAT) + GeneralConstants.NUM_EQUIPMENT_SLOTS) + GeneralConstants.NUM_INVENTORY_SLOTS);
                        (_arg1 as Player).equipment_[_local10] = _local8;
                        break;
                    case StatData.NEW_CON_STAT:
                        _arg1.condition_[ConditionEffect.CE_SECOND_BATCH] = _local8;
                        break;
                }
            }
        }

        private function setPlayerSkinTemplate(_arg1:Player, _arg2:int):void{
            var _local3:Reskin = (this.messages.require(RESKIN) as Reskin);
            _local3.skinID = _arg2;
            _local3.player = _arg1;
            _local3.consume();
        }

        private function processObjectStatus(_arg1:ObjectStatusData, _arg2:int, _arg3:int):void{
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:CharacterClass;
            var _local13:XML;
            var _local14:String;
            var _local15:String;
            var _local16:int;
            var _local17:ObjectProperties;
            var _local18:ProjectileProperties;
            var _local19:Array;
            var _local4:AbstractMap = gs_.map;
            var _local5:GameObject = _local4.goDict_[_arg1.objectId_];
            if (_local5 == null){
                return;
            }
            var _local6 = (_arg1.objectId_ == this.playerId_);
            if (((!((_arg2 == 0))) && (!(_local6)))){
                _local5.onTickPos(_arg1.pos_.x_, _arg1.pos_.y_, _arg2, _arg3);
            }
            var _local7:Player = (_local5 as Player);
            if (_local7 != null){
                _local8 = _local7.level_;
                _local9 = _local7.exp_;
                _local10 = _local7.skinId;
                _local11 = _local7.currFame_;
            }
            this.updateGameObject(_local5, _arg1.stats_, _local6);
            if (_local7){
                if (_local6){
                    _local12 = this.classesModel.getCharacterClass(_local7.objectType_);
                    if (_local12.getMaxLevelAchieved() < _local7.level_){
                        _local12.setMaxLevelAchieved(_local7.level_);
                    }
                }
                if (_local7.skinId != _local10){
                    if (ObjectLibrary.skinSetXMLDataLibrary_[_local7.skinId] != null){
                        _local13 = (ObjectLibrary.skinSetXMLDataLibrary_[_local7.skinId] as XML);
                        _local14 = _local13.attribute("color");
                        _local15 = _local13.attribute("bulletType");
                        if (((!((_local8 == -1))) && ((_local14.length > 0)))){
                            _local7.levelUpParticleEffect(int(_local14));
                        }
                        if (_local15.length > 0){
                            _local7.projectileIdSetOverrideNew = _local15;
                            _local16 = _local7.equipment_[0];
                            _local17 = ObjectLibrary.propsLibrary_[_local16];
                            _local18 = _local17.projectiles_[0];
                            _local7.projectileIdSetOverrideOld = _local18.objectId_;
                        }
                    }
                    else {
                        if (ObjectLibrary.skinSetXMLDataLibrary_[_local7.skinId] == null){
                            _local7.projectileIdSetOverrideNew = "";
                            _local7.projectileIdSetOverrideOld = "";
                        }
                    }
                }
                if (((!((_local8 == -1))) && ((_local7.level_ > _local8)))){
                    if (_local6){
                        _local19 = gs_.model.getNewUnlocks(_local7.objectType_, _local7.level_);
                        _local7.handleLevelUp(!((_local19.length == 0)));
                        if (_local19.length > 0){
                            this.newClassUnlockSignal.dispatch(_local19);
                        }
                    }
                    else {
                        if (!Parameters.data_.noAllyNotifications){
                            _local7.levelUpEffect(TextKey.PLAYER_LEVELUP);
                        }
                    }
                }
                else {
                    if (((!((_local8 == -1))) && ((_local7.exp_ > _local9)))){
                        if (((_local6) || (!(Parameters.data_.noAllyNotifications)))){
                            _local7.handleExpUp((_local7.exp_ - _local9));
                        }
                    }
                }
                if (((((Parameters.data_.showFameGain) && (!((_local11 == -1))))) && ((_local7.currFame_ > _local11)))){
                    if (_local6){
                        _local7.updateFame((_local7.currFame_ - _local11));
                    }
                }
                this.socialModel.updateFriendVO(_local7.getName(), _local7);
            }
        }

        private function onInvResult(_arg1:Socket):void{
            if (_arg1.readInt() != 0){
                this.handleInvFailure();
            }
        }

        private function handleInvFailure():void{
            SoundEffectLibrary.play("error");
            gs_.hudView.interactPanel.redraw();
        }

        private function onReconnect(_arg1:Socket):void{

            var name_:String = _arg1.readUTF();
            var host_:String = _arg1.readUTF();
            var stats_:String = _arg1.readUTF();
            var port_:int = _arg1.readInt();
            var gameId_:int = _arg1.readInt();
            var keyTime_:int = _arg1.readInt();
            isFromArena_ = _arg1.readBoolean();

            var key_:ByteArray = new ByteArray();
            key_.endian = Endian.LITTLE_ENDIAN;
            key_.length = 0;
            _arg1.readBytes(key_, 0, _arg1.readShort());

            var _local2:Server = new Server().setName(name_).setAddress((((host_)!="") ? host_ : server_.address)).setPort((((host_)!="") ? port_ : server_.port));
            if (stats_) {
                statsTracker.setBinaryStringData(charId_, stats_);
            }
            isNexusing = false;
            var _local8:ReconnectEvent = new ReconnectEvent(_local2, gameId_, createCharacter_, charId_, keyTime_, key_, isFromArena_);
            gs_.dispatchEvent(_local8);
        }

        private function onPing(_arg1:Socket):void{

            var serial:int = _arg1.readInt();

            var _local2:Pong = (this.messages.require(PONG) as Pong);
            _local2.serial_ = serial;
            _local2.time_ = getTimer();
            serverConnection.sendMessage(_local2);
        }

        private function onMapInfo(_arg1:Socket):void{

            var width = _arg1.readInt();
            var height = _arg1.readInt();
            var name = _arg1.readUTF();
            var displayName = _arg1.readUTF();
            var fp = _arg1.readUnsignedInt();
            var difficulty = _arg1.readInt();
            var allowPlayerTeleport = _arg1.readBoolean();
            var showDisplays = _arg1.readBoolean();
            var maxPlayers = _arg1.readShort();
            connectionGuid = _arg1.readUTF();
            var gameOpenedTime = _arg1.readUnsignedInt();

            changeMapSignal.dispatch();
            this.closeDialogs.dispatch();
            gs_.applyMapInfo(width, height, name, displayName, difficulty, allowPlayerTeleport, showDisplays);
            this.rand_ = new Random(fp);
            if (createCharacter_){
                this.create();
            }
            else {
                this.load();
            }
        }

        private function onPic(_arg1:Pic):void{
            gs_.addChild(new PicView(_arg1.bitmapData_));
        }

        private function onDeath(_arg1:Death):void{
            this.death = _arg1;
            var _local2:BitmapData = new BitmapDataSpy(gs_.stage.stageWidth, gs_.stage.stageHeight);
            _local2.draw(gs_);
            _arg1.background = _local2;
            if (!gs_.isEditor){
                this.handleDeath.dispatch(_arg1);
            }
            if (gs_.map.name_ == "Davy Jones' Locker"){
                this.showHideKeyUISignal.dispatch(false);
            }
        }

        private function onBuyResult(_arg1:BuyResult):void{
            if (_arg1.result_ == BuyResult.SUCCESS_BRID){
                if (outstandingBuy_ != null){
                    outstandingBuy_.record();
                }
            }
            outstandingBuy_ = null;
            this.handleBuyResultType(_arg1);
        }

        private function handleBuyResultType(_arg1:BuyResult):void{
            var _local2:ChatMessage;
            switch (_arg1.result_){
                case BuyResult.UNKNOWN_ERROR_BRID:
                    _local2 = ChatMessage.make(Parameters.SERVER_CHAT_NAME, _arg1.resultString_);
                    this.addTextLine.dispatch(_local2);
                    return;
                case BuyResult.NOT_ENOUGH_GOLD_BRID:
                    this.showPopupSignal.dispatch(new NotEnoughGoldDialog());
                    return;
                case BuyResult.NOT_ENOUGH_FAME_BRID:
                    this.openDialog.dispatch(new NotEnoughFameDialog());
                    return;
                default:
                    this.handleDefaultResult(_arg1);
            }
        }

        private function handleDefaultResult(_arg1:BuyResult):void{
            var _local2:LineBuilder = LineBuilder.fromJSON(_arg1.resultString_);
            var _local3:Boolean = (((_arg1.result_ == BuyResult.SUCCESS_BRID)) || ((_arg1.result_ == BuyResult.PET_FEED_SUCCESS_BRID)));
            var _local4:ChatMessage = ChatMessage.make(((_local3) ? Parameters.SERVER_CHAT_NAME : Parameters.ERROR_CHAT_NAME), _local2.key);
            _local4.tokens = _local2.tokens;
            this.addTextLine.dispatch(_local4);
        }

        private function onAccountList(_arg1:AccountList):void{
            if (_arg1.accountListId_ == 0){
                if (_arg1.lockAction_ != -1){
                    if (_arg1.lockAction_ == 1){
                        gs_.map.party_.setStars(_arg1);
                    }
                    else {
                        gs_.map.party_.removeStars(_arg1);
                    }
                }
                else {
                    gs_.map.party_.setStars(_arg1);
                }
            }
            else {
                if (_arg1.accountListId_ == 1){
                    gs_.map.party_.setIgnores(_arg1);
                }
            }
        }

        private function onQuestObjId(_arg1:QuestObjId):void{
            gs_.map.quest_.setObject(_arg1.objectId_);
        }

        private function onAoe(_arg1:Aoe):void{
            var _local4:int;
            var _local5:Vector.<uint>;
            if (this.player == null){
                this.aoeAck(gs_.lastUpdate_, 0, 0);
                return;
            }
            var _local2:AOEEffect = new AOEEffect(_arg1.pos_.toPoint(), _arg1.radius_, _arg1.color_);
            gs_.map.addObj(_local2, _arg1.pos_.x_, _arg1.pos_.y_);
            if (((this.player.isInvincible()) || (this.player.isPaused()))){
                this.aoeAck(gs_.lastUpdate_, this.player.x_, this.player.y_);
                return;
            }
            var _local3 = (this.player.distTo(_arg1.pos_) < _arg1.radius_);
            if (_local3){
                _local4 = GameObject.damageWithDefense(_arg1.damage_, this.player.defense_, _arg1.armorPierce_, this.player.condition_);
                _local5 = null;
                if (_arg1.effect_ != 0){
                    _local5 = new Vector.<uint>();
                    _local5.push(_arg1.effect_);
                }
                this.player.damage(true, _local4, _local5, false, null, _arg1.armorPierce_);
            }
            this.aoeAck(gs_.lastUpdate_, this.player.x_, this.player.y_);
        }

        private function onNameResult(_arg1:NameResult):void{
            gs_.dispatchEvent(new NameResultEvent(_arg1));
        }

        private function onGuildResult(_arg1:GuildResult):void{
            var _local2:LineBuilder;
            if (_arg1.lineBuilderJSON == ""){
                gs_.dispatchEvent(new GuildResultEvent(_arg1.success_, "", {}));
            }
            else {
                _local2 = LineBuilder.fromJSON(_arg1.lineBuilderJSON);
                this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local2.key, -1, -1, "", false, _local2.tokens));
                gs_.dispatchEvent(new GuildResultEvent(_arg1.success_, _local2.key, _local2.tokens));
            }
        }

        private function onClientStat(_arg1:ClientStat):void{
            var _local2:Account = StaticInjectorContext.getInjector().getInstance(Account);
            _local2.reportIntStat(_arg1.name_, _arg1.value_);
        }

        private function onFile(_arg1:File):void{
            new FileReference().save(_arg1.file_, _arg1.filename_);
        }

        private function onInvitedToGuild(_arg1:InvitedToGuild):void{
            if (Parameters.data_.showGuildInvitePopup){
                gs_.hudView.interactPanel.setOverride(new GuildInvitePanel(gs_, _arg1.name_, _arg1.guildName_));
            }
            this.addTextLine.dispatch(ChatMessage.make("", (((((("You have been invited by " + _arg1.name_) + " to join the guild ") + _arg1.guildName_) + '.\n  If you wish to join type "/join ') + _arg1.guildName_) + '"')));
        }

        private function onPlaySound(_arg1:PlaySound):void{
            var _local2:GameObject = gs_.map.goDict_[_arg1.ownerId_];
            ((_local2) && (_local2.playSound(_arg1.soundId_)));
        }

        private function onImminentArenaWave(_arg1:ImminentArenaWave):void{
            this.imminentWave.dispatch(_arg1.currentRuntime);
        }

        private function onArenaDeath(_arg1:ArenaDeath):void{
            this.currentArenaRun.costOfContinue = _arg1.cost;
            this.openDialog.dispatch(new ContinueOrQuitDialog(_arg1.cost, false));
            this.arenaDeath.dispatch();
        }

        private function onVerifyEmail(_arg1:VerifyEmail):void{
            TitleView.queueEmailConfirmation = true;
            if (gs_ != null){
                gs_.closed.dispatch();
            }
            var _local2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
            if (_local2 != null){
                _local2.dispatch();
            }
        }

        private function onPasswordPrompt(_arg1:PasswordPrompt):void{
            if (_arg1.cleanPasswordStatus == 3){
                TitleView.queuePasswordPromptFull = true;
            }
            else {
                if (_arg1.cleanPasswordStatus == 2){
                    TitleView.queuePasswordPrompt = true;
                }
                else {
                    if (_arg1.cleanPasswordStatus == 4){
                        TitleView.queueRegistrationPrompt = true;
                    }
                }
            }
            if (gs_ != null){
                gs_.closed.dispatch();
            }
            var _local2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
            if (_local2 != null){
                _local2.dispatch();
            }
        }

        override public function questFetch():void{
            serverConnection.sendMessage(this.messages.require(QUEST_FETCH_ASK));
        }

        private function onQuestFetchResponse(_arg1:QuestFetchResponse):void{
            this.questFetchComplete.dispatch(_arg1);
        }

        private function onQuestRedeemResponse(_arg1:QuestRedeemResponse):void{
            this.questRedeemComplete.dispatch(_arg1);
        }

        override public function questRedeem(_arg1:String, _arg2:Vector.<SlotObjectData>, _arg3:int=-1):void{
            var _local4:QuestRedeem = (this.messages.require(QUEST_REDEEM) as QuestRedeem);
            _local4.questID = _arg1;
            _local4.item = _arg3;
            _local4.slots = _arg2;
            serverConnection.sendMessage(_local4);
        }

        override public function resetDailyQuests():void{
            var _local1:ResetDailyQuests = (this.messages.require(RESET_DAILY_QUESTS) as ResetDailyQuests);
            serverConnection.sendMessage(_local1);
        }

        override public function keyInfoRequest(_arg1:int):void{
            var _local2:KeyInfoRequest = (this.messages.require(KEY_INFO_REQUEST) as KeyInfoRequest);
            _local2.itemType_ = _arg1;
            serverConnection.sendMessage(_local2);
        }

        private function onKeyInfoResponse(_arg1:KeyInfoResponse):void{
            this.keyInfoResponse.dispatch(_arg1);
        }

        private function onLoginRewardResponse(_arg1:ClaimDailyRewardResponse):void{
            this.claimDailyRewardResponse.dispatch(_arg1);
        }

        private function onRealmHeroesResponse(_arg1:RealmHeroesResponse):void{
            this.realmHeroesSignal.dispatch(_arg1.numberOfRealmHeroes);
        }

        private function onClosed():void{
            var _local2:HideMapLoadingSignal;
            var _local3:Server;
            var _local4:ReconnectEvent;
            if (!this.isNexusing){
                if (this.playerId_ != -1){
                    gs_.closed.dispatch();
                }
                else {
                    if (this.retryConnection_){
                        if (this.delayBeforeReconnect < 10){
                            if (this.delayBeforeReconnect == 6){
                                _local2 = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
                                _local2.dispatch();
                            }
                            this.retry(this.delayBeforeReconnect++);
                            if (!this.serverFull_){
                                this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Connection failed!  Retrying..."));
                            }
                        }
                        else {
                            gs_.closed.dispatch();
                        }
                    }
                }
            }
            else {
                this.isNexusing = false;
                _local3 = this.serverModel.getServer();
                _local4 = new ReconnectEvent(_local3, Parameters.NEXUS_GAMEID, false, charId_, 1, new ByteArray(), isFromArena_);
                gs_.dispatchEvent(_local4);
            }
        }

        private function retry(_arg1:int):void{
            this.retryTimer_ = new Timer((_arg1 * 1000), 1);
            this.retryTimer_.addEventListener(TimerEvent.TIMER_COMPLETE, this.onRetryTimer);
            this.retryTimer_.start();
        }

        private function onRetryTimer(_arg1:TimerEvent):void{
            serverConnection.connect(server_.address, server_.port, this);
        }

        private function onError(_arg1:String):void{
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _arg1));
        }

        private function onFailure(_arg1:Failure):void{
            lastConnectionFailureMessage = _arg1.errorDescription_;
            lastConnectionFailureID = _arg1.errorConnectionId_;
            this.serverFull_ = false;
            switch (_arg1.errorId_){
                case Failure.INCORRECT_VERSION:
                    this.handleIncorrectVersionFailure(_arg1);
                    return;
                case Failure.BAD_KEY:
                    this.handleBadKeyFailure(_arg1);
                    return;
                case Failure.INVALID_TELEPORT_TARGET:
                    this.handleInvalidTeleportTarget(_arg1);
                    return;
                case Failure.EMAIL_VERIFICATION_NEEDED:
                    this.handleEmailVerificationNeeded(_arg1);
                    return;
                case Failure.TELEPORT_REALM_BLOCK:
                    this.handleRealmTeleportBlock(_arg1);
                    return;
                case Failure.WRONG_SERVER_ENTERED:
                    this.handleWrongServerEnter(_arg1);
                    return;
                case Failure.SERVER_QUEUE_FULL:
                    this.handleServerFull(_arg1);
                    return;
                default:
                    this.handleDefaultFailure(_arg1);
            }
        }

        private function handleEmailVerificationNeeded(_arg1:Failure):void{
            this.retryConnection_ = false;
            gs_.closed.dispatch();
        }

        private function handleRealmTeleportBlock(_arg1:Failure):void{
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, (("You need to wait at least " + _arg1.errorDescription_) + " seconds before a non guild member teleport.")));
            this.player.nextTeleportAt_ = (getTimer() + (int(_arg1.errorDescription_) * 1000));
        }

        private function handleWrongServerEnter(_arg1:Failure):void{
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, _arg1.errorDescription_));
            this.retryConnection_ = false;
            gs_.closed.dispatch();
        }

        private function handleServerFull(_arg1:Failure):void{
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, _arg1.errorDescription_));
            this.retryConnection_ = true;
            this.delayBeforeReconnect = 5;
            this.serverFull_ = true;
            var _local2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
            _local2.dispatch();
        }

        private function handleInvalidTeleportTarget(_arg1:Failure):void{
            var _local2:String = LineBuilder.getLocalizedStringFromJSON(_arg1.errorDescription_);
            if (_local2 == ""){
                _local2 = _arg1.errorDescription_;
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local2));
            this.player.nextTeleportAt_ = 0;
        }

        private function handleBadKeyFailure(_arg1:Failure):void{
            var _local2:String = LineBuilder.getLocalizedStringFromJSON(_arg1.errorDescription_);
            if (_local2 == ""){
                _local2 = _arg1.errorDescription_;
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local2));
            this.retryConnection_ = false;
            gs_.closed.dispatch();
        }

        private function handleIncorrectVersionFailure(_arg1:Failure):void{
            var _local2:Dialog = new Dialog(TextKey.CLIENT_UPDATE_TITLE, "", TextKey.CLIENT_UPDATE_LEFT_BUTTON, null, "/clientUpdate");
            _local2.setTextParams(TextKey.CLIENT_UPDATE_DESCRIPTION, {
                client:Parameters.CLIENT_VERSION,
                server:_arg1.errorDescription_
            });
            _local2.addEventListener(Dialog.LEFT_BUTTON, this.onDoClientUpdate);
            gs_.stage.addChild(_local2);
            this.retryConnection_ = false;
        }

        private function handleDefaultFailure(_arg1:Failure):void{
            var _local2:String = LineBuilder.getLocalizedStringFromJSON(_arg1.errorDescription_);
            if (_local2 == ""){
                _local2 = _arg1.errorDescription_;
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local2));
        }

        private function onDoClientUpdate(_arg1:Event):void{
            var _local2:Dialog = (_arg1.currentTarget as Dialog);
            _local2.parent.removeChild(_local2);
            gs_.closed.dispatch();
        }

        override public function isConnected():Boolean{
            return (serverConnection.isConnected());
        }


    }
}//package kabam.rotmg.messaging.impl

