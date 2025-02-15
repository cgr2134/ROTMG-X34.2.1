﻿// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.mapeditor.ObjectChooser

package com.company.assembleegameclient.mapeditor{
    import flash.utils.Dictionary;
    import com.company.assembleegameclient.mapeditor.Layer;
    import com.company.assembleegameclient.mapeditor.GroupDivider;
    import com.company.util.MoreStringUtil;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.mapeditor.*;

    class ObjectChooser extends Chooser {

        private var cache:Dictionary;
        private var lastSearch:String = "";

        public function ObjectChooser(){
            super(Layer.OBJECT);
            this.cache = new Dictionary();
        }

        public function getLastSearch():String{
            return (this.lastSearch);
        }

        public function reloadObjects(_arg1:String=""):void{
            var _local3:RegExp;
            var _local5:String;
            var _local6:XML;
            var _local7:int;
            var _local8:ObjectElement;
            removeElements();
            this.lastSearch = _arg1;
            var _local2:Vector.<String> = new Vector.<String>();
            if (_arg1 != ""){
                _local3 = new RegExp(_arg1, "gix");
            }
            var _local4:Dictionary = GroupDivider.GROUPS["Basic Objects"];
            for each (_local6 in _local4) {
                _local5 = String(_local6.@id);
                if ((((_local3 == null)) || ((_local5.search(_local3) >= 0)))){
                    _local2.push(_local5);
                }
            }
            _local2.sort(MoreStringUtil.cmp);
            for each (_local5 in _local2) {
                _local7 = ObjectLibrary.idToType_[_local5];
                _local6 = ObjectLibrary.xmlLibrary_[_local7];
                if (!this.cache[_local7]){
                    _local8 = new ObjectElement(_local6);
                    this.cache[_local7] = _local8;
                }
                else {
                    _local8 = this.cache[_local7];
                }
                addElement(_local8);
            }
            hasBeenLoaded = true;
            scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
        }


    }
}//package com.company.assembleegameclient.mapeditor

