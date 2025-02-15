﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel

package io.decagames.rotmg.supportCampaign.data{
    import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
    import flash.utils.Dictionary;
    import kabam.rotmg.core.StaticInjectorContext;
    import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
    import io.decagames.rotmg.supportCampaign.signals.MaxRankReachedSignal;
    import flash.display.DisplayObject;
    import com.company.assembleegameclient.util.TimeUtil;
    import io.decagames.rotmg.utils.date.TimeLeft;

    public class SupporterCampaignModel {

        public static const DEFAULT_DONATE_AMOUNT:int = 100;
        public static const DEFAULT_DONATE_SPINNER_STEP:int = 100;
        public static const DONATE_MAX_INPUT_CHARS:int = 5;
        public static const SUPPORT_COLOR:Number = 13395711;
        public static const RANKS_NAMES:Array = ["Basic", "Greater", "Superior", "Paramount", "Exalted", "Unbound"];

        private var _unlockPrice:int;
        private var _points:int;
        private var _rank:int;
        private var _tempRank:int;
        private var _donatePointsRatio:int;
        private var _shopPurchasePointsRatio:int;
        private var _endDate:Date;
        private var _activeUntil:Date;
        private var _startDate:Date;
        private var _ranks:Array;
        private var _isUnlocked:Boolean;
        private var _hasValidData:Boolean;
        private var _claimed:int;
        private var _rankConfig:Vector.<RankVO>;
        private var _picUrls:Vector.<String>;
        private var _campaignImages:Dictionary;
        private var _campaignTitle:String;
        private var _campaignDescription:String;
        private var _campaignBannerUrl:String;
        private var _maxRank:int;

        public function SupporterCampaignModel(){
            this._campaignImages = new Dictionary(true);
            super();
        }

        public function parseConfigData(_arg1:XML):void{
            this._hasValidData = _arg1.hasOwnProperty("CampaignConfig");
            if (this._hasValidData){
                this.parseConfig(_arg1);
            }
            if (_arg1.hasOwnProperty("CampaignProgress")){
                this.parseUpdateData(_arg1.CampaignProgress, false);
            }
        }

        public function updatePoints(_arg1:int):void{
            this._points = _arg1;
            this._rank = this.getRankByPoints(this._points);
            StaticInjectorContext.getInjector().getInstance(UpdateCampaignProgress).dispatch();
        }

        public function getRankByPoints(_arg1:int):int{
            var _local3:int;
            if (!this.hasValidData){
                return (0);
            }
            var _local2:int;
            if (((!((this._ranks == null))) && ((this._ranks.length > 0)))){
                _local3 = 0;
                while (_local3 < this._ranks.length) {
                    if (_arg1 >= this._ranks[_local3]){
                        _local2 = (_local3 + 1);
                    }
                    _local3++;
                }
            }
            return (_local2);
        }

        public function get rankConfig():Vector.<RankVO>{
            return (this._rankConfig);
        }

        public function parseUpdateData(_arg1:Object, _arg2:Boolean=true):void{
            this._isUnlocked = (int(this.getXMLData(_arg1, "Unlocked", false)) === 1);
            this._points = int(this.getXMLData(_arg1, "Points", false));
            this._rank = int(this.getXMLData(_arg1, "Rank", false));
            if (this._tempRank == 0){
                this._tempRank = this._rank;
            }
            this._claimed = int(this.getXMLData(_arg1, "Claimed", false));
            if (_arg2){
                StaticInjectorContext.getInjector().getInstance(UpdateCampaignProgress).dispatch();
            }
            if (this.hasMaxRank()){
                StaticInjectorContext.getInjector().getInstance(MaxRankReachedSignal).dispatch();
            }
        }

        private function parseConfig(_arg1:XML):void{
            var _local4:XML;
            this._campaignTitle = this.getXMLData(_arg1.CampaignConfig, "Title", true);
            this._campaignDescription = this.getXMLData(_arg1.CampaignConfig, "Description", true);
            this._campaignBannerUrl = this.getXMLData(_arg1.CampaignConfig, "BannerUrl", true);
            this._unlockPrice = int(this.getXMLData(_arg1.CampaignConfig, "UnlockPrice", true));
            this._donatePointsRatio = int(this.getXMLData(_arg1.CampaignConfig, "DonatePointsRatio", true));
            this._endDate = new Date((int(this.getXMLData(_arg1.CampaignConfig, "CampaignEndDate", true)) * 1000));
            this._activeUntil = new Date((int(this.getXMLData(_arg1.CampaignConfig, "CampaignActiveUntil", true)) * 1000));
            this._startDate = new Date((int(this.getXMLData(_arg1.CampaignConfig, "CampaignStartDate", true)) * 1000));
            this._ranks = this.getXMLData(_arg1.CampaignConfig, "RanksList", true).split(",");
            if (this._ranks){
                this._maxRank = this._ranks.length;
            }
            this._shopPurchasePointsRatio = int(this.getXMLData(_arg1.CampaignConfig, "ShopPurchasePointsRatio", true));
            this._rankConfig = new Vector.<RankVO>();
            var _local2:int;
            while (_local2 < this._ranks.length) {
                this._rankConfig.push(new RankVO(this._ranks[_local2], SupporterCampaignModel.RANKS_NAMES[_local2]));
                _local2++;
            }
            this._picUrls = new <String>[];
            var _local3:XMLList = XML(_arg1.CampaignConfig.PicUrls).children();
            for each (_local4 in _local3) {
                this._picUrls.push(_local4);
            }
        }

        private function parseConfigStatus(_arg1:XML):void{
            this._isUnlocked = (int(this.getXMLData(_arg1.CampaignProgress, "Unlocked", false)) === 1);
            this._points = int(this.getXMLData(_arg1.CampaignProgress, "Points", false));
            this._rank = int(this.getXMLData(_arg1.CampaignProgress, "Rank", false));
            this._claimed = int(this.getXMLData(_arg1, "Claimed", false));
        }

        private function getXMLData(_arg1:Object, _arg2:String, _arg3:Boolean):String{
            if (_arg1.hasOwnProperty(_arg2)){
                return (String(_arg1[_arg2]));
            }
            if (_arg3){
                this._hasValidData = false;
            }
            return ("");
        }

        public function getCampaignImageByUrl(_arg1:String):DisplayObject{
            return ((this._campaignImages[_arg1] as DisplayObject));
        }

        public function addCampaignImageByUrl(_arg1:String, _arg2:DisplayObject):void{
            if (!this._campaignImages[_arg1]){
                this._campaignImages[_arg1] = _arg2;
            }
        }

        public function getCampaignPictureUrlByRank(_arg1:int):String{
            var _local2 = "";
            if (((((this._picUrls) && ((this._picUrls.length > 0)))) && ((_arg1 <= this._picUrls.length)))){
                _arg1 = (((_arg1 == 0)) ? 1 : _arg1);
                _local2 = this._picUrls[(_arg1 - 1)];
            }
            return (_local2);
        }

        public function get isStarted():Boolean{
            return ((new Date().time >= this._startDate.time));
        }

        public function get isEnded():Boolean{
            return ((new Date().time >= this._endDate.time));
        }

        public function get isActive():Boolean{
            return (((this.isStarted) && ((new Date().time < this._activeUntil.time))));
        }

        public function get nextClaimableTier():int{
            var _local2:String;
            if (this._ranks.length == 0){
                return (1);
            }
            var _local1:int = 1;
            for each (_local2 in this._ranks) {
                if ((((this._rank >= _local1)) && ((this._claimed < _local1)))){
                    return (_local1);
                }
                _local1++;
            }
            return (this._rank);
        }

        public function getStartTimeString():String{
            var _local1 = "";
            var _local2:Number = this.getSecondsToStart();
            if (_local2 <= 0){
                return ("");
            }
            if (_local2 > TimeUtil.DAY_IN_S){
                _local1 = (_local1 + TimeLeft.parse(_local2, "%dd %hh"));
            }
            else {
                if (_local2 > TimeUtil.HOUR_IN_S){
                    _local1 = (_local1 + TimeLeft.parse(_local2, "%hh %mm"));
                }
                else {
                    if (_local2 > TimeUtil.MIN_IN_S){
                        _local1 = (_local1 + TimeLeft.parse(_local2, "%mm %ss"));
                    }
                    else {
                        _local1 = (_local1 + TimeLeft.parse(_local2, "%ss"));
                    }
                }
            }
            return (_local1);
        }

        private function getSecondsToStart():Number{
            var _local1:Date = new Date();
            return (((this._startDate.time - _local1.time) / 1000));
        }

        public function get unlockPrice():int{
            return (this._unlockPrice);
        }

        public function get donatePointsRatio():int{
            return (this._donatePointsRatio);
        }

        public function get shopPurchasePointsRatio():int{
            return (this._shopPurchasePointsRatio);
        }

        public function get ranks():Array{
            return (this._ranks);
        }

        public function get isUnlocked():Boolean{
            return (this._isUnlocked);
        }

        public function get hasValidData():Boolean{
            return (this._hasValidData);
        }

        public function get endDate():Date{
            return (this._endDate);
        }

        public function get points():int{
            return (this._points);
        }

        public function get rank():int{
            return (this._rank);
        }

        public function get claimed():int{
            return (this._claimed);
        }

        public function get tempRank():int{
            return (this._tempRank);
        }

        public function set tempRank(_arg1:int):void{
            this._tempRank = _arg1;
        }

        public function get startDate():Date{
            return (this._startDate);
        }

        public function get campaignTitle():String{
            return (this._campaignTitle);
        }

        public function get campaignDescription():String{
            return (this._campaignDescription);
        }

        public function get campaignBannerUrl():String{
            return (this._campaignBannerUrl);
        }

        public function hasMaxRank():Boolean{
            return ((this._rank == this._maxRank));
        }


    }
}//package io.decagames.rotmg.supportCampaign.data

