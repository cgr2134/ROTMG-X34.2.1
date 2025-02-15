﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//kabam.rotmg.account.web.view.WebAccountDetailDialog

package kabam.rotmg.account.web.view{
    import com.company.assembleegameclient.account.ui.Frame;
    import org.osflash.signals.Signal;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import com.company.assembleegameclient.ui.DeprecatedClickableText;
    import org.osflash.signals.natives.NativeMappedSignal;
    import flash.events.MouseEvent;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import flash.filters.DropShadowFilter;

    public class WebAccountDetailDialog extends Frame {

        public var cancel:Signal;
        public var change:Signal;
        public var logout:Signal;
        public var verify:Signal;
        private var loginText:TextFieldDisplayConcrete;
        private var emailText:TextFieldDisplayConcrete;
        private var verifyTitle:TextFieldDisplayConcrete;
        private var verifyEmail:DeprecatedClickableText;
        private var changeText:DeprecatedClickableText;
        private var logoutText:DeprecatedClickableText;
        private var headerText:String;

        public function WebAccountDetailDialog(_arg1:String="WebAccountDetailDialog.title", _arg2:String="WebAccountDetailDialog.loginText"){
            super(_arg1, "", "WebAccountDetailDialog.rightButton");
            this.headerText = _arg2;
            this.makeLoginText();
            this.makeEmailText();
            h_ = (h_ + 88);
            this.cancel = new NativeMappedSignal(rightButton_, MouseEvent.CLICK);
            this.change = new Signal();
            this.logout = new Signal();
            this.verify = new Signal();
        }

        public function setUserInfo(_arg1:String, _arg2:Boolean):void{
            this.emailText.setStringBuilder(new StaticStringBuilder(_arg1));
            if (_arg2){
                this.makeVerifyEmailText();
            }
            this.makeChangeText();
            this.makeLogoutText();
        }

        private function makeVerifyEmailText():void{
            if (this.verifyEmail != null){
                removeChild(this.verifyTitle);
            }
            this.verifyTitle = new TextFieldDisplayConcrete().setSize(18).setColor(0xFF00);
            this.verifyTitle.setBold(true);
            this.verifyTitle.setStringBuilder(new LineBuilder().setParams("Email verified!"));
            this.verifyTitle.filters = [new DropShadowFilter(0, 0, 0)];
            this.verifyTitle.y = (h_ - 110);
            this.verifyTitle.x = 17;
            addChild(this.verifyTitle);
        }

        private function makeChangeText():void{
            if (this.changeText != null){
                removeChild(this.changeText);
            }
            this.changeText = new DeprecatedClickableText(12, false, "Change password");
            this.changeText.addEventListener(MouseEvent.CLICK, this.onChange);
            addNavigationText(this.changeText);
        }

        private function onChange(_arg1:MouseEvent):void{
            this.change.dispatch();
        }

        private function makeLogoutText():void{
            if (this.logoutText != null){
                removeChild(this.logoutText);
            }
            this.logoutText = new DeprecatedClickableText(12, false, "Not you? Log out");
            this.logoutText.addEventListener(MouseEvent.CLICK, this.onLogout);
            addNavigationText(this.logoutText);
        }

        private function onLogout(_arg1:MouseEvent):void{
            this.logout.dispatch();
        }

        private function makeLoginText():void{
            this.loginText = new TextFieldDisplayConcrete().setSize(12).setColor(0xB3B3B3);
            this.loginText.setStringBuilder(new LineBuilder().setParams(this.headerText));
            this.loginText.y = (h_ - 65);
            this.loginText.x = 17;
            addChild(this.loginText);
        }

        private function makeEmailText():void{
            this.emailText = new TextFieldDisplayConcrete().setSize(16).setColor(0xFFFFFF);
            this.emailText.y = (h_ - 50);
            this.emailText.x = 17;
            addChild(this.emailText);
        }

        private function onVerifyEmail(_arg1:MouseEvent):void{
            this.verify.dispatch();
            this.verifyEmail.makeStatic("WebAccountDetailDialog.sent");
        }


    }
}//package kabam.rotmg.account.web.view

