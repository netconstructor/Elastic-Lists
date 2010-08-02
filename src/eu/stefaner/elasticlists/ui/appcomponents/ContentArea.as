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

package eu.stefaner.elasticlists.ui.appcomponents {	import eu.stefaner.elasticlists.App;	import eu.stefaner.elasticlists.data.ContentItem;	import eu.stefaner.elasticlists.data.DataItem;	import eu.stefaner.elasticlists.layout.TileLayout;	import eu.stefaner.elasticlists.ui.DefaultGraphicsFactory;	import eu.stefaner.elasticlists.ui.contentitem.ContentItemSprite;
	import flare.animate.TransitionEvent;	import flare.animate.Transitioner;	import flare.util.Strings;	import flare.vis.Visualization;	import flare.vis.data.Data;
	import org.osflash.thunderbolt.Logger;
	import flash.display.Sprite;	import flash.events.Event;	import flash.text.TextField;	import flash.utils.Dictionary;
	public class ContentArea extends Sprite {
		public var RESULTS_TEXT : String = "{0} resources found";
		public var DELAY_PER_ELEMENT : Number = 0;
		public var app : App;		public var visualization : Visualization;		public var bg : Sprite;		public var title_tf : TextField;		public var selectedContentItem : ContentItem = null;		protected var transitioner : Transitioner;		protected var firstRun : Boolean = true;		public var maxItems : uint = 30;		public var TRANSITION_DURATION : Number = 1;		public var sortField : String;
		public var layoutMode : String = "TILE_LAYOUT";
		public static const TILE_LAYOUT: String = "TILE_LAYOUT";
		public static const LIST_LAYOUT : String = "LIST_LAYOUT";
		protected var contentItemSpriteForContentItemID : Dictionary = new Dictionary();

		public function ContentArea() {			super();			initGraphics();		}
		public function init(a : App) : void {			this.app = a;			app.addEventListener(App.CONTENTITEMS_CHANGED, onContentItemsChanged, false, 0, true);			app.addEventListener(App.FILTERS_CHANGED, onFilteredContentItemsChanged, false, 0, true);						initVisualization();					layout();		}
		protected function layout() : void {			title_tf.x = 3;			title_tf.y = 2;			visualization.x = 5;			visualization.y = 24;			visualization.bounds.height = height - visualization.y - 2;			visualization.bounds.width = width - 10;			updateVisualization(false);		}

		protected function initGraphics() : void {			if(!bg) {				bg = DefaultGraphicsFactory.getContentAreaBackground();				addChildAt(bg, 0);			}			if(!title_tf) {				title_tf = DefaultGraphicsFactory.getTitleTextField();				addChild(title_tf);			}		}
		protected function initVisualization() : void {			visualization = new Visualization(new Data());
			if(layoutMode == TILE_LAYOUT){
				visualization.operators.add(new TileLayout(2, TileLayout.SCALE_TO_FIXED_SIZE));
			} else if(layoutMode == LIST_LAYOUT){
				visualization.operators.add(new TileLayout(2, TileLayout.FIXED_WIDTH));
			}						addChild(visualization);					}
		//---------------------------------------		// GETTER / SETTERS		//---------------------------------------		override public function set height( h : Number ) : void { 			bg.height = h;			layout();		}
		override public function get height() : Number { 			return bg.height; 		}
		override public function set width( h : Number ) : void { 			bg.width = h;			layout();		}
		override public function get width() : Number { 			return bg.width; 		}
		//---------------------------------------		// PUBLIC METHODS		//---------------------------------------		public function updateContentItems() : void {			Logger.info("ContentArea.updateContentItems", app.model.allContentItems.length);			visualization.data.nodes.setProperty("forRemoval", true);						for each(var contentItem:ContentItem in app.model.allContentItems) {				var sprite : ContentItemSprite = contentItemSpriteForContentItemID[contentItem.id]; 				if(!sprite) {					sprite = contentItemSpriteForContentItemID[contentItem.id] = app.createContentItemSprite(contentItem);					contentItem.addEventListener(DataItem.SELECTION_STATUS_CHANGE, onContentItemSelection, false, 0, true);				}								if(!visualization.data.nodes.contains(sprite)) visualization.data.addNode(sprite);				contentItemSpriteForContentItemID[contentItem.id].forRemoval = false; 			}						if(sortField) {				visualization.data.nodes.sortBy(sortField);			}		}
		public function onContentItemSelection(e : Event) : void {			Logger.info("ContentArea.onContentItemSelection " + e.target);			var c : ContentItem = ContentItem(e.target);			if(selectedContentItem != null && c.selected) {				// click on currently selected item				// will directly trigger this function again via the listener!				selectedContentItem.selected = false;			}			if(!c.selected) {				selectedContentItem = null;			} else {				selectedContentItem = c;			}						app.showDetails(selectedContentItem);			updateVisualization(false);					};
		private function onContentItemsChanged(event : Event) : void {			updateContentItems();			updateVisualization();			updateTitle();		}
		public function onFilteredContentItemsChanged(e : Event) : void {				updateContentItems();			updateVisualization();			updateTitle();		};
		private function updateTitle() : void {			title_tf.text = Strings.format(RESULTS_TEXT, app.model.filteredContentItems.length);
		}

		protected function refreshTransitioner(fluidTransition : Boolean = true) : void {			if(transitioner && transitioner.running) {				transitioner.stop();			}			transitioner = createTransitioner();			transitioner.addEventListener(TransitionEvent.END, onTransitionEnd);			transitioner.immediate = firstRun || !fluidTransition;			firstRun = false;		}
		private function onTransitionEnd(event : TransitionEvent) : void {			for each(var contentItemSprite:ContentItemSprite in visualization.data.nodes) {				if(contentItemSprite.forRemoval) visualization.data.remove(contentItemSprite);			}	
		}

		protected function createTransitioner() : Transitioner {
			return new Transitioner(TRANSITION_DURATION);
		}

		public function updateVisualization(fluidTransition : Boolean = true) : void {			Logger.info("ContentArea.updateVisualization");						refreshTransitioner(fluidTransition);						/*			if(sortField) {			visualization.data.nodes.sortBy(sortField);			}			 * 			 */			var counter : Number = 0;						visualization.update(transitioner);			if(DELAY_PER_ELEMENT) {				for each(var contentItemSprite:ContentItemSprite in visualization.data.nodes) {					if(contentItemSprite.isVisible) {						transitioner.setDelay(contentItemSprite, DELAY_PER_ELEMENT * counter++);					} else {						transitioner.setDelay(contentItemSprite, 0);					}				}				}			transitioner.play();		};	}}