 /*
   
  Copyright 2010, Moritz Stefaner

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
*/

package eu.stefaner.elasticlists.ui {
	import flash.text.AntiAliasType;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author mo
	 */
	public class DefaultGraphicsFactory {

		[Embed(source="/assets/PTS55F.ttf", fontName="regularFont", advancedAntiAliasing="true", mimeType="application/x-font-truetype")]

		private var regularFont : Class;
		
		[Embed(source="/assets/Aller_Bd.ttf", fontName="boldFont",  fontWeight='bold',  advancedAntiAliasing="true", mimeType="application/x-font-truetype")]

		private var boldFont : Class;

		public static function getTextField() : TextField {
			var t : TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.multiline = false;
			t.embedFonts = true;
			t.antiAliasType = AntiAliasType.ADVANCED;
			var tf : TextFormat = new TextFormat("regularFont", 10, 0x333333);
			t.defaultTextFormat = tf;
		
			return t;
		}

		public static function getFacetBoxContainerBackground() : Sprite {
			var s : Sprite = getPanelBackground();
			s.filters = [new DropShadowFilter(2, 45, 0, .2)];
			return s;
		}

		public static function getFacetBoxBackground() : Sprite {
			return getPanelBackground();
		}

		public static function getContentItemBackground() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0xFFFFFF);
			s.graphics.lineStyle(0, 0xCCCCCC, 1);
			s.graphics.drawRect(0, 0, 200, 100);
			//s.filters = [new DropShadowFilter(2, 45, 0, .2)];
			return s;
		}

		public static function getSelectionMarker() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0xDDFF99);
			s.graphics.drawRect(0, 0, 100, 100);
			return s;
		}

		public static function getTitleTextField() : TextField {
			var t : TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.multiline = false;
			t.embedFonts = true;
			t.antiAliasType = AntiAliasType.ADVANCED;
			var tf : TextFormat = new TextFormat("boldFont", 12, 0x333333, true);
			t.defaultTextFormat = tf;
			return t;
		}

		public static function getPanelBackground() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0xFFFFFF, 1);
			s.graphics.drawRect(0, 0, 100, 100);
			return s;
		}

		public static function getContentAreaBackground() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0xF0F0F0, 0);
			s.graphics.drawRect(0, 0, 100, 100);
			return s;
		}

		public static function getElasticListEntryBackground() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0xFFFFFF);
			//s.graphics.lineStyle(0, 0xCCCCCC, 1);
			s.graphics.drawRect(0, 0, 200, 100);
			s.filters = [new DropShadowFilter(2, 45, 0, .2)];
			return s;
		}

		public static function getMapMarkerBackground() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0x333333);
			//s.graphics.lineStyle(0, 0xCCCCCC, 1);
			s.graphics.drawCircle(0, 0, 1);
			return s;
		}

		public static function getMapMarkerSelectionMarker() : Sprite {
			var s : Sprite = new Sprite();
			s.graphics.beginFill(0xDDFF99);
			//s.graphics.lineStyle(0, 0xCCCCCC, 1);
			s.graphics.drawCircle(0, 0, 1);
			return s;
		}
	}
}
