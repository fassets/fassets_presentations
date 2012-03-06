$(function(){
  var resize_slots = function(){
    height = $(window).height();
    width = $(window).width();
    $("#slot_top").css("height", height*0.35 + 'px');
    $("#slot_top").css("width", width*0.67 + 'px');
    $("#slot_bottom").css("height", height*0.35 + 'px');
    $("#slot_bottom").css("width", width*0.67 + 'px');
    $("#slot_topleft").css("height", height*0.35 + 'px');
    $("#slot_topleft").css("width", width*0.33 + 'px');
    $("#slot_topright").css("height", height*0.35 + 'px');
    $("#slot_topright").css("width", width*0.33 + 'px');
    $("#slot_left").css("height", height*0.4 + 'px');
    $("#slot_left").css("width", width*0.33 + 'px');
    $("#slot_right").css("height", height*0.4 + 'px');
    $("#slot_right").css("width", width*0.33 + 'px');
    $("#slot_center").css("height", height*0.7 + 'px');
    $("#slot_center").css("width", width*0.67 + 'px');
    $("#slot_subtitle").css("height", height*0.35 + 'px');
    $("#slot_subtitle").css("width", width*0.67 + 'px');
    $("#slot_centertitle").css("height", height*0.35 + 'px');
    $("#slot_centertitle").css("width", width*0.67 + 'px');
    $("textarea").each(function(i,e) {
      parent = $(e).parent();
      $(e).css("height", parent.height()*0.9);
      $(e).css("width", parent.width()*0.9);
    });
    $("img.fit").scaleImage({
      parent: "li",
      scale: 'fit',
      center: false
    });
    $("#slot_bottom .slot_asset img").scaleImage({
      parent: "li",
      scale: 'fit',
      center: true
    });
    $("#slot_center .slot_asset img").scaleImage({
      parent: "li",
      scale: 'fit',
      center: true
    });
  }
  resize_slots();
  $('.wysiwyg .slot_textarea').wysiwyg({
    controls: {
        strikeThrough: { visible: true },
        underline: { visible: true },
        subscript: { visible: true },
        superscript: { visible: true },
        justifyLeft: { visible: false},
        justifyCenter: { visible: false},
        justifyRight: { visible: false},
        justifyFull: { visible: false},
        subscript: { visible: false},
        superscript: { visible: false},
        createLink: { visible: false},
        insertImage: { visible: false},
        insertHorizontalRule: { visible: false},
        h1: {}
    },
    autoSave: true,
    css:  '/assets/fassets_presentations/templates/default/editor.css'
  });
});

