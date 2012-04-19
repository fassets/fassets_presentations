/*!
 * Mercury Editor is a CoffeeScript and jQuery based WYSIWYG editor.  Documentation and other useful information can be
 * found at https://github.com/jejacks0n/mercury
 *
 * Supported browsers:
 *   - Firefox 4+
 *   - Chrome 10+
 *   - Safari 5+
 *
 * Copyright (c) 2011 Jeremy Jackson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 *= require_self
 *
 * Minimum jQuery requirements are 1.7
 *= require mercury/dependencies/jquery-1.7
 *
 * You can include the Rails jQuery ujs script here to get some nicer behaviors in modals, panels and lightviews when
 * using :remote => true within the contents rendered in them.
 * require jquery_ujs
 *
 * If you want to override Mercury functionality, you can do so in a custom file that binds to the mercury:loaded event,
 * or do so at the end of the current file (mercury.js).  There's an example that will help you get started.
 * require mercury_overrides
 *
 * Add all requires for the support libraries that integrate nicely with Mercury Editor.
 *= require mercury/support/history
 *
 * Require Mercury Editor itself.
 *= require mercury/mercury
 *
 * Require any localizations you wish to support
 * Example: es.locale, or fr.locale -- regional dialects are in each language file so never en_US for instance.
 * require mercury/locales/swedish_chef.locale
 *
 * Add all requires for plugins that extend or change the behavior of Mercury Editor.
 * require mercury/plugins/save_as_xml/plugin.js
 */
window.Mercury = {

  // # Mercury Configuration
  config: {
    // ## Toolbars
    //
    // This is where you can customize the toolbars by adding or removing buttons, or changing them and their
    // behaviors.  Any top level object put here will create a new toolbar.  Buttons are simply nested inside the
    // toolbars, along with button groups.
    //
    // Some toolbars are custom (the snippetable toolbar for instance), and to denote that use _custom: true.  You can
    // then build the toolbar yourself with it's own behavior.
    //
    // Buttons can be grouped, and a button group is simply a way to wrap buttons for styling -- they can also handle
    // enabling or disabling all the buttons within it by using a context.  The table button group is a good example
    // of this.
    //
    // It's important to note that each of the button names (keys), in each toolbar object must be unique, regardless
    // of if it's in a button group, or nested, etc.  This is because styling is applied to them by name, and because
    // their name is used in the event that's fired when you click on them.
    //
    // Button format: `[label, description, {type: action, type: action, etc}]`
    //
    // ### The available button types are:
    //
    // - toggle:    toggles on or off when clicked, otherwise behaves like a button
    // - modal:     opens a modal window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - lightview: opens a lightview window (like modal, but different UI), expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - panel:     opens a panel dialog, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - palette:   opens a palette window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - select:    opens a pulldown style window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - context:   calls a callback function, expects the action to be:
    //   1. a function that returns a boolean to highlight the button
    //   note: if a function isn't provided, the key will be passed to the contextHandler, in which case a default
    //         context will be used (for more info read the Contexts section below)
    // - mode:      toggle a given mode in the editor, expects the action to be:
    //   1. a string, denoting the name of the mode
    //   note: it's assumed that when a specific mode is turned on, all other modes will be turned off, which happens
    //         automatically, thus putting the editor into a specific "state"
    // - regions:   allows buttons to be enabled/disabled based on what region type has focus, expects the action to be:
    //   1. an array of region types (eg. ['editable', 'markupable'])
    // - preload:   allows some dialog views to be loaded when the button is created instead of on first open, expects:
    //   1. a boolean true / false
    //   note: this is only used by panels, selects, and palettes
    //
    // Separators are any "button" that's not an array, and are expected to be a string.  You can use two different
    // separator styles: line ('-'), and spacer (' ').
    //
    // ### Adding Contexts
    //
    // Contexts are used callback functions used for highlighting and disabling/enabling buttons and buttongroups.  When
    // the cursor enters an element within an html region for instance we want to disable or highlight buttons based on
    // the properties of the given node.  You can see examples of contexts in, and add your own to:
    // `Mercury.Toolbar.Button.contexts` and `Mercury.Toolbar.ButtonGroup.contexts`
    toolbars: {
      primary: {
        save:                  ['Save', 'Save this page'],
        showFrame:             ['Preview', 'Open preview window'],
        sep1:                  ' ',
        undoredo:              {
          undo:                ['Undo', 'Undo your last action'],
          redo:                ['Redo', 'Redo your last action'],
          sep:                 ' '
          },
        insertTable:           ['Table', 'Insert Table', { modal: '/mercury/modals/table.html', regions: ['editable', 'markupable'] }],
        insertCharacter:       ['Character', 'Special Characters', { modal: '/mercury/modals/character.html', regions: ['editable', 'markupable'] }     ],
        sep3: ' ',
        newFrame:              ['New', 'Create a new frame'],
        templatePanel:         ['Template', 'Change the Template', { panel: '/presentations/templates' }],
        renamePanel:           ['Rename', 'Rename the Frame'],
        deleteFrame:           ['Delete', 'Delete Frame'],
        sep2: ' ',
        editPresentation:      ["Edit Presentation", "Edit Presentation Properties"],
        sep3: ' ',
        markupEditor:          ["Markup Editor", "Switch to the Markup editor"],
        sep4: ' ',
        exitEditor:            ["Exit", "Leave the Editor"]
        },

      editable: {
        _regions:              ['editable', 'markupable'],
        header:                {
          header1:             ['H1', null, { context: true }],
          header2:             ['H2', null, { context: true }],
          header3:             ['H3', null, { context: true }],
          sep:                 '-'
        },
        decoration:            {
          bold:                ['Bold', null, { context: true }],
          italic:              ['Italicize', null, { context: true }],
          overline:            ['Overline', null, { context: true, regions: ['editable'] }],
          strikethrough:       ['Strikethrough', null, { context: true, regions: ['editable'] }],
          underline:           ['Underline', null, { context: true, regions: ['editable'] }],
          sep:                 '-'
          },
        dmarkup:               {
          definition:          ['Definition', 'Inserts a definition with a title and text', { context: true }],
          example:             ['Example', 'Inserts an example with a title and text', { context: true }],
          box:                 ['Box', 'Inserts a box with a title and text', { context: true }],
          cite:                ['Citation','Inserts a quote with a citation', { context: true }],
          foreign:             ['Foreign', 'Inserts a foreign word with translation'],
          sep:                 '-'
        },
        list:                  {
          insertUnorderedList: ['Unordered List', null, { context: true }],
          insertOrderedList:   ['Numbered List', null, { context: true }],
          sep:                 '-'
          },
        indent:                {
          outdent:             ['Decrease Indentation'],
          indent:              ['Increase Indentation'],
          sep:                 '-'
          },
        table:                 {
          _context:            true,
          insertRowBefore:     ['Insert Table Row', 'Insert a table row before the cursor', { regions: ['editable'] }],
          insertRowAfter:      ['Insert Table Row', 'Insert a table row after the cursor', { regions: ['editable'] }],
          deleteRow:           ['Delete Table Row', 'Delete this table row', { regions: ['editable'] }],
          insertColumnBefore:  ['Insert Table Column', 'Insert a table column before the cursor', { regions: ['editable'] }],
          insertColumnAfter:   ['Insert Table Column', 'Insert a table column after the cursor', { regions: ['editable'] }],
          deleteColumn:        ['Delete Table Column', 'Delete this table column', { regions: ['editable'] }],
          sep1:                ' ',
          increaseColspan:     ['Increase Cell Columns', 'Increase the cells colspan'],
          decreaseColspan:     ['Decrease Cell Columns', 'Decrease the cells colspan and add a new cell'],
          increaseRowspan:     ['Increase Cell Rows', 'Increase the cells rowspan'],
          decreaseRowspan:     ['Decrease Cell Rows', 'Decrease the cells rowspan and add a new cell'],
          sep2:                '-'
          },
        rules:                 {
          horizontalRule:      ['Horizontal Rule', 'Insert a horizontal rule'],
          sep1:                '-'
          },
        formatting:            {
          removeFormatting:    ['Remove Formatting', 'Remove formatting for the selection', { regions: ['editable'] }],
          sep2:                ' '
          }
        },

      snippetable: {
        _custom:               true,
        actions:               {
          editSnippet:         ['Edit Snippet Settings'],
          sep1:                ' ',
          removeSnippet:       ['Remove Snippet']
          }
        }
      },


    // ## Region Options
    //
    // You can customize some aspects of how regions are found, identified, and saved.
    //
    // className: Mercury identifies editable regions by a className.  This classname has to be added in your HTML in
    // advance, and is the only real code/naming exposed in the implementation of Mercury.  To allow this to be as
    // configurable as possible, you can set the name of the class.  When switching to preview mode, this configuration
    // is also used to generate a class to indicate that Mercury is in preview mode by appending it with '-preview' (so
    // by default it would be mercury-region-preview)
    //
    // identifier: This is used as a unique identifier for any given region (and thus should be unique to the page).
    // By default this is the id attribute but can be changed to a data attribute should you want to use something
    // custom instead.
    //
    // dataAttributes: The dataAttributes is an array of data attributes that will be serialized and returned to the
    // server upon saving.  These attributes, when applied to a Mercury region element, will be automatically serialized
    // and submitted with the AJAX request sent when a page is saved.  These are expected to be HTML5 data attributes,
    // and 'data-' will automatically be prepended to each item in this directive. (ex. ['scope', 'version'])
    regions: {
      className: 'mercury-region',
      identifier: 'id',
      dataAttributes: []
      },


    // ## Snippet Options / Preview
    //
    // When a user drags a snippet onto the page they'll be prompted to enter options for the given snippet.  The server
    // is expected to respond with a form.  Once the user submits this form, an Ajax request is sent to the server with
    // the options provided; this preview request is expected to respond with the rendered markup for the snippet.
    //
    // method: The HTTP method used when submitting both the options and the preview.  We use POST by default because a
    // snippet options form may contain large text inputs and we don't want that to be truncated when sent to the
    // server.
    //
    // optionsUrl: The url that the options form will be loaded from.
    //
    // previewUrl: The url that the options will be submitted to, and will return the rendered snippet markup.
    //
    // **Note:** `:name` will be replaced with the snippet name in the urls (eg. /mercury/snippets/example/options.html)
    snippets: {
      method: 'POST',
      optionsUrl: '/mercury/snippets/:name/options.html',
      previewUrl: '/mercury/snippets/:name/preview.html'
      },


    // ## Image Uploading
    //
    // If you drag images from your desktop into regions that support it, it will be uploaded to the server and inserted
    // into the region.  You can disable or enable this feature, the accepted mime-types, file size restrictions, and
    // other things related to uploading.
    //
    // **Note:** Image uploading is only supported in some region types, and some browsers.
    //
    // enabled: You can set this to true, or false if you want to disable the feature entirely.
    //
    // allowedMimeTypes: You can restrict the types of files that can be uploaded by providing a list of allowed mime
    // types.
    //
    // maxFileSize: You can restrict large files by setting the maxFileSize (in bytes).
    //
    // inputName: When uploading, a form is generated and submitted to the server via Ajax.  If your server would prefer
    // a different name for how the image comes through, you can change the inputName.
    //
    // url: The url that the image upload will be submitted to.
    //
    // handler: You can use false to let Mercury handle it for you, or you can provide a handler function that can
    // modify the response from the server.  This can be useful if your server doesn't respond the way Mercury expects.
    // The handler function should take the response from the server and return an object that matches:
    // `{image: {url: '[your provided url]'}`
    uploading: {
      enabled: false,
      allowedMimeTypes: ['image/jpeg', 'image/gif', 'image/png'],
      maxFileSize: 1235242880,
      inputName: 'image[image]',
      url: '/mercury/images',
      handler: false
      },


    // ## Localization / I18n
    //
    // Include the .locale files you want to support when loading Mercury.  The files are always named by the language,
    // and not the regional dialect (eg. en.locale.js) because the regional dialects are nested within the primary
    // locale files.
    //
    // The client locale will be used first, and if no proper locale file is found for their language then the fallback
    // preferredLocale configuration will be used.  If one isn't provided, and the client locale isn't included, the
    // strings will remain untranslated.
    //
    // enabled: Set to false to disable, true to enable.
    //
    // preferredLocale: If a client doesn't support the locales you've included, this is used as a fallback.
    localization: {
      enabled: false,
      preferredLocale: 'swedish_chef-BORK'
      },


    // ## Behaviors
    //
    // Behaviors are used to change the default behaviors of a given region type when a given button is clicked.  For
    // example, you may prefer to add HR tags using an HR wrapped within a div with a classname (for styling).  You
    // can add your own complex behaviors here and they'll be shared across all regions.
    //
    // If you want to add behaviors to specific region types, you can mix them into the actions property of any region
    // type.
    //
    //     Mercury.Regions.Editable.actions.htmlEditor = function() {}
    //
    // You can see how the behavior matches up directly with the button names.  It's also important to note that the
    // callback functions are executed within the scope of the given region, so you have access to all it's methods.
    behaviors: {
      //foreColor: function(selection, options) { selection.wrap('<span style="color:' + options.value.toHex() + '">', true) },
      showFrame: function() {
        var presentation_id = $('#mercury_iframe').contents().find("#main").attr("presentation_id");
        var frame_id = $('#mercury_iframe').contents().find("#main").attr("frame_id");
        //$('#mercury_iframe').contents().find("html").load('/presentations/'+presentation_id+'/frame/'+frame_id+'/show');
        Mercury.previewWindow = window.open('/presentations/'+presentation_id+'/frame/'+frame_id);          
      },
      editPresentation: function() {
        $('#mercury_iframe').contents().find("#edit_presentation_button").click();
      },
      deleteFrame: function() {
        $('#mercury_iframe').contents().find("#delete_frame_button").click();
      },
      markupEditor: function() {
        edit_url = $('#mercury_iframe').contents().find("#markup_button").parent().parent().attr("action");
        window.location.href = edit_url;
      },
      header1: function(selection) {
        var text = selection.textContent();
        if (selection.commonAncestor().attr("class") != "clear"){
          if (selection.commonAncestor().get(0).tagName == "H1"){
            selection.commonAncestor().replaceWith(text);
          }else{
            selection.commonAncestor().replaceWith('<h1>'+text+'</h1>');
          }
        }else{
          selection.replace('<h1>'+text+'</h1>')
        } 
      },
      header2: function(selection) {
        var text = selection.textContent();
        if (selection.commonAncestor().attr("class") != "clear"){
          if (selection.commonAncestor().get(0).tagName == "H2"){
            selection.commonAncestor().replaceWith(text);
          }else{
            selection.commonAncestor().replaceWith('<h2>'+text+'</h2>');
          }
        }else{
          selection.replace('<h2>'+text+'</h2>')
        } 
      },
      header3: function(selection) {
        var text = selection.textContent();
        if (selection.commonAncestor().attr("class") != "clear"){
          if (selection.commonAncestor().get(0).tagName == "H3"){
            selection.commonAncestor().replaceWith(text);
          }else{
            selection.commonAncestor().replaceWith('<h3>'+text+'</h3>');
          }
        }else{
          selection.replace('<h3>'+text+'</h3>')
        } 
      },
      definition: function(selection) {
        if (selection.textContent() != ""){
          var title = prompt('Enter the definition title:');
          content = selection.content();
          var text = $("<div></div>").append(content).html();
          selection.replace('<div class="definition"><div class="type">Definition:</div><div class="title">'+title+'</div><div class="delete">X</div><div class="content">'+text+'</div></div>');
        }else{
          var title = prompt('Enter the definition title:');
          var text = prompt('Enter the definition text:');
          if (title != "" && text != ""){
            selection.replace('<div class="definition"><div class="type">Example:</div><div class="title">'+title+'</div><div class="delete">X</div><div class="content">'+text+'</div></div>');
          }     
        }
      },
      example: function(selection) {
        
        if (selection.textContent() != ""){
          var title = prompt('Enter the example title:');
          content = selection.content();
          text = $("<div></div>").append(content).html();
          selection.replace('<div class="example"><div class="type">Example:</div><div class="title">'+title+'</div><div class="delete">X</div><div class="content">'+text+'</div></div>');
        }else{
          var title = prompt('Enter the example title:');
          var text = prompt('Enter the example text:');
          if (title != "" && text != ""){
            selection.replace('<div class="example"><div class="type">Example:</div><div class="title">'+title+'</div><div class="delete">X</div><div class="content">'+text+'</div></div>');
          }     
        }
      },
      box: function(selection) {
        if (selection.textContent() != ""){
          var title = prompt('Enter the box title:');
          content = selection.content();
          text = $("<div></div>").append(content).html();
          selection.replace('<div class="box"><div class="title">'+title+'</div><div class="delete">X</div><div class="content">'+text+'</div></div>');
        }else{
          var title = prompt('Enter the box title:');
          var text = prompt('Enter the box text:');
          if (title != "" && text != ""){
            selection.replace('<div class="box"><div class="title">'+title+'</div><div class="delete">X</div><div class="content">'+text+'</div></div>');
          }
        }
      },
      foreign: function(selection) {
        if (selection.textContent() != ""){
          var translation = prompt('Enter the translation:');
          var term = selection.textContent();
          selection.replace('<div class="foreign"><div class="title">'+term+'</div><div class="translation">('+translation+')</div></div>');
        }else{
          var term = prompt('Enter the term:');
          var translation = prompt('Enter the translation:');
          if (term != "" && translation != ""){
            selection.replace('<div class="foreign"><div class="title">'+term+'</div><div class="translation">('+translation+')</div></div>');
          }
        }
      },
      cite: function(selection) {
        if (selection.textContent() != ""){
          var key = prompt('Enter the BibTeX-key for the citation:');
          content = selection.content();
          quote = $("<div></div>").append(content).html();
          if (quote != "" && key != ""){
            var citation = "";
            $.get('/presentations/citation?bibkey='+key, function(retdata){
              citation = retdata;
              selection.replace('<div class="cite"><div class="quote">'+quote+'</div><div class="citation" id="'+key+'">'+citation+'</div></div>');
            });
          }
        }else{
          var quote = prompt('Enter the quote:');
          var key = prompt('Enter the BibTeX-key for the citation:');
          if (quote != "" && key != ""){
            var citation = "";
            $.get('/presentations/citation?bibkey='+key, function(retdata){
              citation = retdata;
              selection.replace('<div class="cite"><div class="quote">'+quote+'</div><div class="citation" id="'+key+'">'+citation+'</div></div>');
            });
          }
        }
      },
      renamePanel: function(){
        var title = prompt("Please enter the new name for the frame:", $('#mercury_iframe').contents().find(".frame_title").val());
        var presentation_id = $('#mercury_iframe').contents().find("#main").attr("presentation_id");
        var frame_id = $('#mercury_iframe').contents().find("#main").attr("frame_id");
        var data = {title: title};
        $.post("/presentations/"+presentation_id+"/frame/"+frame_id+"/rename", data, function(retdata){
          $('#mercury_iframe').contents().find(".sortable_frames #frame_"+frame_id+" #"+frame_id).text(title);
          $('#mercury_iframe').contents().find("body h1 #title a").text(title);
          $('#mercury_iframe').contents().find(".frame_title").val(title)
        });
      },
      newFrame: function(){
        var presentation_id = $('#mercury_iframe').contents().find("#main").attr("presentation_id");
        var frame_id = $('#mercury_iframe').contents().find("#main").attr("frame_id");
        Mercury.modal("/presentations/"+presentation_id+"/frame/"+frame_id+"/new_frame", {title: "New Frame"});
      },
      exitEditor: function(){
        window.location.href = "/";
      }
    },
    // ## Global Behaviors
    //
    // Global behaviors are much like behaviors, but are more "global".  Things like save, exit, etc. can be included
    // here.  They'll only be called once, and execute within the scope of whatever editor is instantiated (eg.
    // PageEditor).
    //
    // An example of changing how saving works:
    //
    //     save: function() {
    //       var data = top.JSON.stringify(this.serialize(), null, '  ');
    //       var content = '<textarea style="width:500px;height:200px" wrap="off">' + data + '</textarea>';
    //       Mercury.modal(null, {title: 'Saving', closeButton: true, content: content})
    //     }
    //
    // This is a nice way to add functionality, when the behaviors aren't region specific.  These can be triggered by a
    // button, or manually with `Mercury.trigger('action', {action: 'barrelRoll'})`
    globalBehaviors: {
      exit: function() { window.location.href = this.iframeSrc() },
      barrelRoll: function() { $('body').css({webkitTransform: 'rotate(360deg)'}) }
      },


    // ## Ajax and CSRF Headers
    //
    // Some server frameworks require that you provide a specific header for Ajax requests.  The values for these CSRF
    // tokens are typically stored in the rendered DOM.  By default, Mercury will look for the Rails specific meta tag,
    // and provide the X-CSRF-Token header on Ajax requests, but you can modify this configuration if the system you're
    // using doesn't follow the same standard.
    csrfSelector: 'meta[name="csrf-token"]',
    csrfHeader: 'X-CSRF-Token',

    // ## Editor URLs
    //
    // When loading a given page, you may want to tweak this regex.  It's to allow the url to differ from the page
    // you're editing, and the url at which you access it.
    editorUrlRegEx: /([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i,

    // ## Hijacking Links & Forms
    //
    // Mercury will hijack links and forms that don't have a target set, or the target is set to _self and will set it
    // to _parent.  This is because the target must be set properly for Mercury to not get in the way of some
    // functionality, like proper page loads on form submissions etc.  Mercury doesn't do this to links or forms that
    // are within editable regions because it doesn't want to impact the html that's saved.  With that being explained,
    // you can add classes to links or forms that you don't want this behavior added to.  Let's say you have links that
    // open a lightbox style window, and you don't want the targets of these to be set to _parent.  You can add classes
    // to this array, and they will be ignored when the hijacking is applied.
    nonHijackableClasses: [],


    // ## Pasting & Sanitizing
    //
    // When pasting content into Mercury it may sometimes contain HTML tags and attributes.  This markup is used to
    // style the content and makes the pasted content look (and behave) the same as the original content.  This can be a
    // desired feature or an annoyance, so you can enable various sanitizing methods to clean the content when it's
    // pasted.
    //
    // sanitize: Can be any of the following:
    // - false: no sanitizing is done, the content is pasted the exact same as it was copied by the user
    // - 'whitelist': content is cleaned using the settings specified in the tag white list (described below)
    // - 'text': all html is stripped before pasting, leaving only the raw text
    //
    // whitelist: The white list allows you to specify tags and attributes that are allowed when pasting content.  Each
    // item in this object should contain the allowed tag, and an array of attributes that are allowed on that tag.  If
    // the allowed attributes array is empty, all attributes will be removed.  If a tag is not present in this list, it
    // will be removed, but without removing any of the text or tags inside it.
    //
    // **Note:** Content is *always* sanitized if looks like it's from MS Word or similar editors regardless of this
    // configuration.
    pasting: {
      sanitize: 'whitelist',
      whitelist: {
        h1:     [],
        h2:     [],
        h3:     [],
        h4:     [],
        h5:     [],
        h6:     [],
        table:  [],
        thead:  [],
        tbody:  [],
        tfoot:  [],
        tr:     [],
        th:     ['colspan', 'rowspan'],
        td:     ['colspan', 'rowspan'],
        div:    ['class'],
        span:   ['class'],
        ul:     [],
        ol:     [],
        li:     [],
        b:      [],
        strong: [],
        i:      [],
        em:     [],
        u:      [],
        strike: [],
        br:     [],
        p:      [],
        hr:     [],
        a:      ['href', 'target', 'title', 'name'],
        img:    ['src', 'title', 'alt']
        }
      },


    // ## Injected Styles
    //
    // Mercury tries to stay as much out of your code as possible, but because regions appear within your document we
    // need to include a few styles to indicate regions, as well as the different states of them (eg. focused).  These
    // styles are injected into your document, and as simple as they might be, you may want to change them.
    //
    // {{regionClass}} will be automatically replaced with whatever you have set in the regions.class config directive.
    injectedStyles: '' +
      '.{{regionClass}} { min-height: 10px; outline: 1px dotted #09F } ' +
      '.{{regionClass}}:focus, .{{regionClass}}.focus { outline: none; -webkit-box-shadow: 0 0 10px #09F, 0 0 1px #045; box-shadow: 0 0 10px #09F, 0 0 1px #045 }' +
      '.{{regionClass}}:after { content: "."; display: block; visibility: hidden; clear: both; height: 0; overflow: hidden; }' +
      '.{{regionClass}} table, .{{regionClass}} td, .{{regionClass}} th { border: 1px dotted black; min-width: 30px; }' +
      '.mercury-textarea { border: 0; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; resize: none; }' +
      '.mercury-textarea:focus { outline: none; }'
  },

  // ## Silent Mode
  //
  // Turning silent mode on will disable asking about unsaved changes before leaving the page.
  silent: false,

  // ## Debug Mode
  //
  // Turning debug mode on will log events and other various things (using console.debug if available).
  debug: false,

  previewWindow: "",
  // The onload method is provided as a callback in case you want to override default Mercury Editor behavior.  It will
  // be called directly after the Mercury scripts have loaded, but before anything has been initialized.  It's a good
  // place to add or change functionality.
  onload: function() {
    //Mercury.PageEditor.prototype.iframeSrc = function(url) { return '/testing'; }
    $('.mercury-panel-pane .template_panel #one_slot').live("click",function(e){
      $('#mercury_iframe').contents().find(".frame_template").val("one_slot");
      $('.mercury-panel-close').click();
      Mercury.trigger('action', {action: 'save'});
    });
    $('.mercury-panel-pane .template_panel #2columns').live("click",function(e){
      $('#mercury_iframe').contents().find(".frame_template").val("2column");
      $('.mercury-panel-close').click();
      Mercury.trigger('action', {action: 'save'});
    });
    $('.mercury-panel-pane .template_panel #2rows').live("click",function(e){
      $('#mercury_iframe').contents().find(".frame_template").val("2rows");
      $('.mercury-panel-close').click();
      Mercury.trigger('action', {action: 'save'});
    });
    $('.mercury-panel-pane .template_panel #top2_bottom1').live("click",function(e){
      $('#mercury_iframe').contents().find(".frame_template").val("top2_bottom1");
      $('.mercury-panel-close').click();
      Mercury.trigger('action', {action: 'save'});
    });
    $('#create_frame_button').live('click', function(e){
      var presentation_id = $('#mercury_iframe').contents().find("#main").attr("presentation_id");
      var title = $('.mercury-modal-content #title').val();
      if (title == ""){
        alert("Title cannot be empty!");
        return
      }
      var template = $('.mercury-modal-content #template').val();
      var parent_id = $('.mercury-modal-content #parent_id').val();
      var data = {"frame": {"title": title, "template": template, "parent_id": parent_id}};
      $.post("/presentations/"+presentation_id+"/new_frame", data, function(retdata){
        window.location.href = retdata;
      });
    });
    Mercury.Toolbar.Button.contexts.header1 = function(node, region){
      if (node.closest('h1', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.Toolbar.Button.contexts.header2 = function(node, region){
      if (node.closest('h2', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.Toolbar.Button.contexts.header3 = function(node, region){
      if (node.closest('h3', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.Toolbar.Button.contexts.definition = function(node, region){
      if (node.closest('.definition', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.Toolbar.Button.contexts.example = function(node, region){
      if (node.closest('.example', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.Toolbar.Button.contexts.box = function(node, region){
      if (node.closest('.box', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.Toolbar.Button.contexts.cite = function(node, region){
      if (node.closest('.cite', region).length > 0){
        return true
      }else{
        return false
      }
    };
    Mercury.PageEditor.prototype.save = function() {
      Mercury.trigger('reinitialize');
      var template = $('#mercury_iframe').contents().find(".frame_template").val();
      var data = {"frame": {"content": this.serialize(), "template": template}};
      var url = $('#mercury_iframe').contents().find('#edit_link').data('save-url');
      $('#mercury_iframe').contents().find(".slot_mode").each(function(){
        data["frame"]["content"][$(this).attr("id").replace("_select","")] = {"mode": $(this).val(), "value": data["frame"]["content"][$(this).attr("id").replace("_select","")]["value"]};
      });
      $('#mercury_iframe').contents().find(".slot_asset_id").each(function(){
        data["frame"]["content"][$(this).attr("id").replace("_asset_id","")] = {"asset_id": $(this).val(), "value": data["frame"]["content"][$(this).attr("id").replace("_asset_id","")]["value"], "mode": data["frame"]["content"][$(this).attr("id").replace("_asset_id","")]["mode"]};
      });
      $('#mercury_iframe').contents().find(".slot_content:visible, .slot_asset:visible").each(function(idx, el){
        if ($(el).attr("id") == "left" || $(el).attr("id") == "right"|| $(el).parent().attr("id") == "slot_left" || $(el).parent().attr("id") == "slot_right"){
          var t_width = $('#mercury_iframe').contents().find('#main').width()-65;
          var t_height = $('#mercury_iframe').contents().find('#main').height();
        }else if ($(el).attr("id") == "top" || $(el).attr("id") == "bottom" || $(el).parent().attr("id") == "slot_top" || $(el).parent().attr("id") == "slot_bottom"){
          var t_width = $('#mercury_iframe').contents().find('#main').width()-20;
          var t_height = $('#mercury_iframe').contents().find('#main').height()-80;          
        }else if ($(el).attr("id") == "topleft" || $(el).attr("id") == "topright" || $(el).parent().attr("id") == "slot_topleft" || $(el).parent().attr("id") == "slot_topright") {
          var t_width = $('#mercury_iframe').contents().find('#main').width()-45;
          var t_height = $('#mercury_iframe').contents().find('#main').height()-100;
        }else if ($(el).attr("id") == "center" || "slot_center") {
          var t_width = $('#mercury_iframe').contents().find('#main').width();
          var t_height = $('#mercury_iframe').contents().find('#main').height();
        }else if ($(el).attr("id") == "centertitle" || "slot_centertitle" || $(el).attr("id") == "subtitle" || "slot_subtitle") {
          var t_width = $('#mercury_iframe').contents().find('#main').width();
          var t_height = $('#mercury_iframe').contents().find('#main').height();
        }
        var width = $(el).width();
        var height = $(el).height();
        var perc_w = ((width/t_width)*100);
        var perc_h = ((height/t_height)*100);
        if ($(this).attr("id") == undefined){
          var id = $(this).parent().attr("id").replace("slot_","");
          var asset_id = data["frame"]["content"][id]["asset_id"];
          var mode = data["frame"]["content"][id]["mode"]
          data["frame"]["content"][id] = $.extend(data["frame"]["content"][id],{"asset_id": asset_id, "mode": mode, "width": perc_w, "height": perc_h});
        }else{
          data["frame"]["content"][$(this).attr("id")] = $.extend(data["frame"]["content"][$(this).attr("id")],{"width": perc_w, "height": perc_h});      
        }
      });
      jQuery.ajax(url, {
        type: 'POST',
        data: data,
        success: function(retdata) {
          Mercury.changes = false;
          if (Mercury.previewWindow != ""){
            Mercury.previewWindow.location.reload();
          }
          if (retdata == "reload"){
            var presentation_id = $('#mercury_iframe').contents().find("#main").attr("presentation_id");
            var frame_id = $('#mercury_iframe').contents().find("#main").attr("frame_id");
            $('#mercury_iframe').contents().find("#container").load("/presentations/"+presentation_id+"/frame/"+frame_id+"/reload_slots", function(){
              Mercury.trigger('reinitialize')
            });
          }
        },
        error: function() { alert("Mercury was unable to save.") }
      });
    };
  },

};
