﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.account.web.commands.WebChangePasswordCommand

package kabam.rotmg.account.web.commands{
    import kabam.rotmg.account.core.services.ChangePasswordTask;
    import kabam.lib.tasks.TaskMonitor;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.core.signals.TaskErrorSignal;
    import kabam.rotmg.core.signals.TrackEventSignal;
    import kabam.lib.tasks.BranchingTask;
    import kabam.lib.tasks.TaskSequence;
    import kabam.lib.tasks.DispatchSignalTask;
    import kabam.rotmg.account.web.view.WebAccountDetailDialog;
    import kabam.lib.tasks.Task;

    public class WebChangePasswordCommand {

        [Inject]
        public var task:ChangePasswordTask;
        [Inject]
        public var monitor:TaskMonitor;
        [Inject]
        public var close:CloseDialogsSignal;
        [Inject]
        public var openDialog:OpenDialogSignal;
        [Inject]
        public var loginError:TaskErrorSignal;


        public function execute():void{
            var _local1:BranchingTask = new BranchingTask(this.task, this.makeSuccess(), this.makeFailure());
            this.monitor.add(_local1);
            _local1.start();
        }

        private function makeSuccess():Task{
            var _local1:TaskSequence = new TaskSequence();
            _local1.add(new DispatchSignalTask(this.openDialog, new WebAccountDetailDialog()));
            return (_local1);
        }

        private function makeFailure():Task{
            return (new DispatchSignalTask(this.loginError, this.task));
        }
    }
}//package kabam.rotmg.account.web.commands

