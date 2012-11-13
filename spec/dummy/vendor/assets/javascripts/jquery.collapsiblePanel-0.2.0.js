/*
 *
 * Copyright (c) 2010 Justin Dearing (zippy1981@gmail.com)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) version 2 licenses.
 * This software is not distributed under version 3 or later of the GPL.
 *
 * Version 0.2.0
 *
*/
(function($) {
/**
 * Wraps a jquery resultset in a collapsible panel.
 *
 * @name collapsiblePanel
 * @param panelId (string) Assigns the given id to the outer div of the collapsible panel.
 * @param titleQuery (jQuery) The elements in ths jQuery are inserted into the title section of the collapsible panel.
 * @param collapsedImage (url) Url of the image to display on top of the panel when the panel is collapsed.
 * @param expandedImage (url) Url of the image to display on top of the panel when the panel is expanded.
 * @param startCollapsed (boolean) Set to true to collapse the panel upon rendering it.
 * @author Justin Dearing (http://zippy1981.dyndns.org)
 * @example $("#tableId").collapsiblePanel();
 *
 */
	//Attach this new method to jQuery
 	$.fn.extend({ 
 		
 		 		
		//pass the options variable to the function
 		collapsiblePanel: function(options) {


			//Set the default values, use comma to separate the settings, example:
			var defaults = {
				panelId: null,
				titleQuery: null,
				collapsedImage: "panelCollapsed.png",
				expandedImage: "panelExpanded.png",
				startCollapsed: false
			}
				
			options = $.extend(defaults, options);

			var collapsePanel = function (panelDiv) {
				panelDiv.find(">div.collapsiblePanelTitle").unbind("click");
				panelDiv.find(">div.collapsiblePanelContents").slideUp("slow");
				collapseTitle(panelDiv.find(">div.collapsiblePanelTitle"));
				panelDiv.find(">div.collapsiblePanelTitle").click(function () {
					expandPanel(panelDiv);
				});
			}
	    	
			var collapseTitle = function (panelTitle) {
				panelTitle.find(">img.collapseExpandToggle").attr("src", options.collapsedImage);
			}
			
			var expandPanel = function (panelDiv) {
				panelDiv.find(">div.collapsiblePanelTitle").unbind("click");
				panelDiv.find(">div.collapsiblePanelContents").slideDown("slow");
				expandTitle(panelDiv.find(">div.collapsiblePanelTitle"));
				panelDiv.find(">div.collapsiblePanelTitle").click(function () {
					collapsePanel(panelDiv);
				});
			}
			
			var expandTitle = function (panelTitle) {
				panelTitle.find(">img.collapseExpandToggle").attr("src", options.expandedImage);
			}
	
			return this.each(function() {
				// Prevent double wrapping.
				var inCollapsiblePanel = $(this).data('inCollapsiblePanel');
				if(inCollapsiblePanel != true)
				{
					$(this).data('inCollapsiblePanel', true);
					var panelContents = $(this);
					panelContents.wrap($('<div class="collapsiblePanelContents"></div>'));
					panelContents = panelContents.parent();
					
					var titleDiv = 
						$('<div class="collapsiblePanelTitle"><img class="collapseExpandToggle" src="' + 
						options.expandedImage + 
						'" alt="" height="16" width="16"/></div>');
					titleDiv.append($(this).find(options.titleQuery).addClass("collapseTitleContents"));
					// Hover cursor
					titleDiv.hover(
						function() { $(this).addClass('collapsiblePanelTitleHover'); },
						function() { $(this).removeClass('collapsiblePanelTitleHover'); }
					);
					
					var panelDiv = $('<div class="collapsiblePanelOuter"></div>');
					if (options.panelId != null) { panelDiv[0].id = options.panelId; }
					
					// It seemed to be wrapping a copy of the div around the contents.
					// We need that copy for the event handling.
					panelDiv = panelContents.wrap(panelDiv).parent();
					
					titleDiv.insertBefore(panelContents);
					if (options.startCollapsed) {
						collapsePanel(panelDiv);
					}
					else {
						titleDiv.click(function () {
							collapsePanel(panelDiv);
						});
					}
				}
			});
		}
	});
	
})(jQuery);
