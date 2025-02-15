﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.core.commands.SetScreenWithValidDataCommand

package kabam.rotmg.core.commands{
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.core.signals.SetScreenSignal;
    import flash.display.Sprite;
    import kabam.lib.tasks.TaskMonitor;
    import kabam.rotmg.account.core.services.GetCharListTask;
    import kabam.rotmg.dailyLogin.tasks.FetchPlayerCalendarTask;
    import io.decagames.rotmg.supportCampaign.tasks.GetCampaignStatusTask;
    import io.decagames.rotmg.pets.tasks.GetOwnedPetSkinsTask;
    import com.company.assembleegameclient.screens.LoadingScreen;
    import kabam.lib.tasks.TaskSequence;
    import kabam.lib.tasks.DispatchSignalTask;

    public class SetScreenWithValidDataCommand {

        [Inject]
        public var model:PlayerModel;
        [Inject]
        public var setScreen:SetScreenSignal;
        [Inject]
        public var view:Sprite;
        [Inject]
        public var monitor:TaskMonitor;
        [Inject]
        public var task:GetCharListTask;
        [Inject]
        public var calendarTask:FetchPlayerCalendarTask;
        [Inject]
        public var campaignStatusTask:GetCampaignStatusTask;
        [Inject]
        public var petSkinsTask:GetOwnedPetSkinsTask;

        public function execute():void{
            if (this.model.isInvalidated){
                this.reloadDataThenSetScreen();
            }
            else {
                this.setScreen.dispatch(this.view);
            }
        }

        private function reloadDataThenSetScreen():void{
            this.setScreen.dispatch(new LoadingScreen());
            var _local1:TaskSequence = new TaskSequence();
            _local1.add(this.task);
            _local1.add(this.calendarTask);
            _local1.add(this.petSkinsTask);
            _local1.add(this.campaignStatusTask);
            _local1.add(new DispatchSignalTask(this.setScreen, this.view));
            this.monitor.add(_local1);
            _local1.start();
        }


    }
}//package kabam.rotmg.core.commands

