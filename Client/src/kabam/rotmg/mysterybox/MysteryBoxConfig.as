﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.mysterybox.MysteryBoxConfig

package kabam.rotmg.mysterybox{
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import kabam.rotmg.startup.control.StartupSequence;
    import kabam.rotmg.mysterybox.services.MysteryBoxModel;
    import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
    import robotlegs.bender.framework.api.*;

    public class MysteryBoxConfig implements IConfig {

        [Inject]
        public var injector:Injector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var commandMap:ISignalCommandMap;
        [Inject]
        public var sequence:StartupSequence;


        public function configure():void{
            this.injector.map(MysteryBoxModel).asSingleton();
            this.injector.map(GetMysteryBoxesTask).asSingleton();
            this.sequence.addTask(GetMysteryBoxesTask, 4);
        }


    }
}//package kabam.rotmg.mysterybox

