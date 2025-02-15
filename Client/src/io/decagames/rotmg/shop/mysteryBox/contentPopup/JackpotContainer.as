﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//io.decagames.rotmg.shop.mysteryBox.contentPopup.JackpotContainer

package io.decagames.rotmg.shop.mysteryBox.contentPopup{
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.texture.TextureParser;

    public class JackpotContainer extends Sprite {

        private const MAX_COLUMNS:int = 5;
        private const ROW_HEIGHT:int = 45;

        private var background:SliceScalingBitmap;
        private var grid:UIGrid;


        public function diamondBackground():void{
            this.background = TextureParser.instance.getSliceScalingBitmap("UI", "mystery_box_jackpot_diamond");
            addChild(this.background);
        }

        public function goldBackground():void{
            this.background = TextureParser.instance.getSliceScalingBitmap("UI", "mystery_box_jackpot_gold");
            addChild(this.background);
        }

        public function silverBackground():void{
            this.background = TextureParser.instance.getSliceScalingBitmap("UI", "mystery_box_jackpot_silver");
            addChild(this.background);
        }

        public function addGrid(_arg1:UIGrid):void{
            this.background.height = (80 + (Math.floor((_arg1.numberOfElements / this.MAX_COLUMNS)) * this.ROW_HEIGHT));
            this.grid = _arg1;
            _arg1.y = 30;
            if (_arg1.numberOfElements <= 5){
                _arg1.x = Math.round(((this.background.width - ((_arg1.numberOfElements * 40) + ((_arg1.numberOfElements - 1) * 4))) / 2));
            }
            else {
                _arg1.x = Math.round(((this.background.width - ((5 * 40) + (4 * 4))) / 2));
            }
            addChild(_arg1);
        }

        public function dispose():void{
            this.background.dispose();
            this.grid.dispose();
        }


    }
}//package io.decagames.rotmg.shop.mysteryBox.contentPopup

