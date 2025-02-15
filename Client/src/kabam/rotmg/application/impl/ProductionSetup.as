﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.application.impl.ProductionSetup

package kabam.rotmg.application.impl{
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.application.api.*;

    public class ProductionSetup implements ApplicationSetup {

        private const SERVER:String = "www.realmofthemadgod.com";
        private const UNENCRYPTED:String = ("http://" + SERVER);
        private const ENCRYPTED:String = ("https://" + SERVER);
        private const BUILD_LABEL:String = "RotMG #{VERSION}.{MINOR}";


        public function getAppEngineUrl(_arg1:Boolean=false):String{
            return (this.ENCRYPTED);
        }

        public function getBuildLabel():String{
            return (this.BUILD_LABEL.replace("{VERSION}", Parameters.CLIENT_VERSION).replace("{MINOR}", ""));
        }

        public function useLocalTextures():Boolean{
            return false;
        }

        public function isToolingEnabled():Boolean{
            return false;
        }

        public function isGameLoopMonitored():Boolean{
            return false;
        }

        public function isServerLocal():Boolean{
            return false;
        }

        public function useProductionDialogs():Boolean{
            return true;
        }

        public function areErrorsReported():Boolean{
            return false;
        }

        public function areDeveloperHotkeysEnabled():Boolean{
            return false;
        }

        public function isDebug():Boolean{
            return false;
        }

        public function getServerDomain():String{
            return (this.SERVER);
        }


    }
}//package kabam.rotmg.application.impl

