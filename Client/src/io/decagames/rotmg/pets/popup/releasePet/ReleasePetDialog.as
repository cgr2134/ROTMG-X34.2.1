﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.pets.popup.releasePet.ReleasePetDialog

package io.decagames.rotmg.pets.popup.releasePet{
    import io.decagames.rotmg.ui.popups.modal.TextModal;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.buttons.BaseButton;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.model.TextKey;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;

    public class ReleasePetDialog extends TextModal {

        private var _releaseButton:SliceScalingButton;
        private var _petId:int;

        public function ReleasePetDialog(_arg1:int){
            this._petId = _arg1;
            var _local2:Vector.<BaseButton> = new Vector.<BaseButton>();
            this._releaseButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this._releaseButton.width = 100;
            this._releaseButton.setLabel(LineBuilder.getLocalizedStringFromKey(TextKey.RELEASE), DefaultLabelFormat.defaultButtonLabel);
            _local2.push(this.releaseButton);
            _local2.push(new ClosePopupButton(LineBuilder.getLocalizedStringFromKey(TextKey.FRAME_CANCEL)));
            super(300, "Release Pet", "Are you sure you want to release this Pet? Once released, you will not be able to get you pet back.", _local2);
        }

        public function get releaseButton():SliceScalingButton{
            return (this._releaseButton);
        }

        public function get petId():int{
            return (this._petId);
        }


    }
}//package io.decagames.rotmg.pets.popup.releasePet

