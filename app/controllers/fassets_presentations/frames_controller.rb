module FassetsPresentations
  class FramesController < ApplicationController
    include AssetsHelper
    include FramesHelper
    before_filter :authenticate_user!, :except => [:show]
    before_filter :find_presentation, :except => [:markup_preview, :to_markdown, :to_html, :citation, :editor, :templates, :rename]
    before_filter :find_frame, :except => [:new, :create, :sort, :markup_preview, :to_markdown, :to_html, :citation, :frames, :editor, :templates, :rename]
    def create
      if params[:id]
        frame = Frame.find(params[:id]).clone();
        frame.presentation_id = @presentation.id
      else
        position = Frame.where(:presentation_id => @presentation.id).maximum(:position)+1
        frame =  Frame.create(params[:frame].merge({:presentation_id => @presentation.id, :position => position}))
      end
      respond_to do |format|
        if frame.save
          update_positions()
          flash[:notice] = "Frame succesfully created!"
          format.html {redirect_to edit_presentation_frame_path(@presentation, frame)}
          format.json {render :status => :created, :json => frame.to_json}
        else
          flash[:error] = "Title of frame cannot be empty"
          format.html {redirect_to edit_presentation_path(@presentation)}
        end
      end
    end
    def edit
      if @frame.parent == nil
        is_root_frame = true
        if @frame.children.first
          @frame = @frame.children.first
          redirect_to edit_presentation_frame_path(@presentation, @frame)
          return
        end
      else
        is_root_frame = false
      end
      render :template => "fassets_presentations/frames/edit", :layout => "fassets_presentations/application", :locals => {:is_root_frame => is_root_frame}
    end
    def showFrame
      logger.debug("Entered Frames#show")
      render :template => "fassets_presentations/frames/show", :layout => "layouts/fassets_presentations/frame"
    end
    def editor
      render :text => '', :layout => 'fassets_presentations/mercury'
    end
    def edit_wysiwyg
      if @frame.parent == nil
        is_root_frame = true
        if @frame.children.first
          @frame = @frame.children.first
          redirect_to edit_wysiwyg_presentation_frame_path(@presentation, @frame)
          return
        end
      else
        is_root_frame = false
      end 
      render :template => "fassets_presentations/frames/edit_wysiwyg", :layout => "fassets_presentations/editor", :locals => {:is_root_frame => is_root_frame}      
    end
    def edit_wysiwyg_save
      if params[:commit] == "Rename"
        @frame.update_attributes(:title => params[:title])
        render :inline => "" 
      end
      begin
        @frame.slots.each do |slot|
          logger.debug("Slot:"+slot.name)
          begin
            logger.debug(html_to_markdown(params[:frame][:content][slot.name][:value]))
            params[:frame][:content][slot.name][:markup] = html_to_markdown(params[:frame][:content][slot.name][:value])
            params[:frame][:content][slot.name].delete(:value)
          rescue
            params[:frame][:content][slot.name][:markup] = ""
            params[:frame][:content][slot.name].delete(:value)      
          end
        end
      rescue
      end
      arrange_slots()
      if params[:frame][:template] != @frame.template
        template_change = true
      end
      @frame.update_attributes(params[:frame])
      if template_change
        render :inline => "reload"
      else
        render :inline => "OK"
      end
    end
    def rename_frame
      @frame.update_attributes(:title => params[:title])
      render :inline => ""
    end
    def frames
      render :partial => "fassets_presentations/presentations/frames", :locals => {:presentation => @presentation, :wysiwyg => true}
    end
    def update
      arrange_slots()
      params[:frame][:content].each do |slot_name, value|
        begin
          to_fp_html(params[:frame][:content][slot_name][:markup])
        rescue
          flash[:error] = "Could not update frame - Invalid markup!"
          redirect_to edit_presentation_frame_path(@presentation, @frame)
          return
        end
      end
      if @frame.update_attributes(params[:frame])
        flash[:notice] = "frame succesfully updated!"
      else
        flash[:error] = "Could not update frame!"
      end
      redirect_to edit_presentation_frame_path(@presentation, @frame)
    end
    def update_wysiwyg
      params[:frame][:content].each do |slot_name, value|
        begin
          params[:frame][:content][slot_name][:markup] = html_to_markdown(params[:frame][:content][slot_name][:markup])
        rescue Exception => ex
          logger.debug("Error:"+ex)
          flash[:error] = "Could not update frame - Conversion to markup failed!"
          render :inline => "Error"
        end
      end
      arrange_slots()
      if params[:frame][:template] != @frame.template
        template_change = true
      end
      if @frame.update_attributes(params[:frame])
        flash[:notice] = "frame succesfully updated!"
      else
        flash[:error] = "Could not update frame!"
      end
      if template_change
        render :inline => "reload"
      else
        render :inline => "OK"
      end
    end
    def show
      redirect_to presentation_path(@presentation) + "##{@frame.position}"
    end
    def destroy
      if @frame.destroy
        flash[:notice] = "frame succesfully deleted!"
      else
        flash[:error] = "Could not delete frame!"
      end
      redirect_to edit_presentation_frame_path(@presentation, @presentation.root_frame)
    end

    def sort
      j = ActiveSupport::JSON
      root_frame = @presentation.root_frame
      frames = j.decode(params[:frame])
      position = 0
      frames.each do |frame|
        frame_id = frame["item_id"]
        if frame_id == "root"
          next
        end
        parent_id = frame["parent_id"]
        if frame["parent_id"] == "root"
          parent_id = root_frame.id
        end
        logger.debug("ID:"+frame_id.to_s+"position:"+position.to_s)
        frame = Frame.find(frame_id)
        frame.update_attribute(:parent_id, parent_id)
        frame.update_attribute(:position, position+1)
        position += 1
      end
      render :nothing => true
    end
    def preview
      content_id = Asset.find(params[:id]).content_id
      @content = self.content_model.find(content_id)
      render :partial => content_model.to_s.underscore.pluralize + "/" + @content.media_type.to_s.underscore + "_preview"
    end
    def markup_preview
      begin
        html = to_fp_html(params["markup"])
      rescue
        render :inline => "Error generating preview - please check the markup"
        return
      end
      render :inline => html
    end
    def to_markdown
      render :inline => html_to_markdown(params[:content])
    end
    def to_html
      if params[:value] == ""
        render :inline => ""
      else
        render :inline => to_fp_html(params[:value])
      end
    end  
    def citation
      key = params["bibkey"]
      citation = "BibTeX-Key not found!"
      begin
        Dir.foreach(Rails.root.to_s+'/app/bibtex/') do |file|
          begin
            unless file == "." or file == ".."
              b = BibTeX.open(Rails.root.to_s+'/app/bibtex/'+file)
              logger.debug(b[key].author)
              if b[key].author.length == 1
                authors = b[key].author[1].last
              elif b[key].author.length == 2
                authors = b[key].author[1].last + " and "+ b[key].author[2].last
              elif b[key].author.length == 3
                authors = b[key].author[1].last + ", "+ b[key].author[2].last + " and "+ b[key].author[2].last
              elif b[key].author.length == 4
                authors = b[key].author[1].last + ", "+ b[key].author[2].last + ", "+ b[key].author[3].last + " and " + b[key].author[4].last
              else
                authors = b[key].author[1].last + ", et al."
              end
              citation = authors+", "+b[key].year.to_s
            end
          rescue Exception => ex
            puts ex
          end
        end
      rescue Exception => ex
        puts ex
      end
      render :inline => citation
    end
    def templates
      render :partial => "fassets_presentations/frames/template"
    end
    def change_template
      old_template = @frame.template
      rearrange_slots(old_template, params[:template])
      params[:frame][:template] = params[:template]
      #@frame.update_attributes(params[:frame])
      render :inline => ""
    end
    def reload_slots
      render :template => "fassets_presentations/frames/edit_wysiwyg", :layout => false, :locals => {:is_root_frame => false}
      #render :partial => "fassets_presentations/frames/slot_wysiwyg", :collection => @frame.slots
    end
  protected
    def find_presentation
      @presentation = Presentation.find(params[:presentation_id])
      @content = @presentation
    end
    def find_frame
      @frame = Frame.find(params[:id])
    end
    def update_positions
      root_frame = @presentation.root_frame
      position = 1
      root_frame.descendants.each do |frame|
        frame.update_attribute(:position, position)
        position += 1
      end
    end
    def arrange_slots
      old_template = @frame.template
      new_template = params[:frame][:template]
      logger.debug("Converting from "+old_template+" to "+new_template)
      if old_template == "2rows"
        if new_template == "2column"
          params[:frame][:content][:left] = params[:frame][:content][:top]
          params[:frame][:content][:left][:width] = params[:frame][:content][:top][:height]
          params[:frame][:content][:left][:height] = params[:frame][:content][:top][:width]
          params[:frame][:content][:right] = params[:frame][:content][:bottom]
          params[:frame][:content][:right][:width] = params[:frame][:content][:bottom][:height]
          params[:frame][:content][:right][:height] = params[:frame][:content][:bottom][:width]
          params[:frame][:content].delete(:top)
          params[:frame][:content].delete(:bottom)
        elsif new_template == "top2_bottom1"
          params[:frame][:content][:topleft] = params[:frame][:content][:top]
          params[:frame][:content][:bottom] = params[:frame][:content][:bottom]
          params[:frame][:content].delete(:top)
          params[:frame][:content].delete(:bottom)
        elsif new_template == "one_slot"
          if params[:frame][:content][:top][:mode] == "markup" && params[:frame][:content][:top][:markup] != ""
            params[:frame][:content][:center] = params[:frame][:content][:top]
            params[:frame][:content].delete(:top)
          elsif params[:frame][:content][:top][:mode] == "asset" && params[:frame][:content][:top][:asset_id] != ""
            params[:frame][:content][:center] = params[:frame][:content][:top]
            params[:frame][:content].delete(:top)
          else
            params[:frame][:content][:center] = params[:frame][:content][:bottom]
            params[:frame][:content].delete(:bottom)                       
          end
        else
          return
        end
      elsif old_template == "2column"
        if new_template == "2rows"
          params[:frame][:content][:top] = params[:frame][:content][:left]
          params[:frame][:content][:top][:width] = params[:frame][:content][:left][:height]
          params[:frame][:content][:top][:height] = params[:frame][:content][:left][:width]
          params[:frame][:content][:bottom] = params[:frame][:content][:right]
          params[:frame][:content][:bottom][:width] = params[:frame][:content][:right][:height]
          params[:frame][:content][:bottom][:height] = params[:frame][:content][:right][:width]
        elsif new_template == "top2_bottom1"
          params[:frame][:content][:topleft] = params[:frame][:content][:left]
          params[:frame][:content][:topright] = params[:frame][:content][:right]
        elsif new_template == "one_slot"
          if params[:frame][:content][:left][:mode] == "markup" && params[:frame][:content][:left][:markup] != ""
            params[:frame][:content][:center] = params[:frame][:content][:left]
            params[:frame][:content].delete(:left)
          elsif params[:frame][:content][:left][:mode] == "asset" && params[:frame][:content][:left][:asset_id] != ""
            params[:frame][:content][:center] = params[:frame][:content][:left]
            params[:frame][:content].delete(:left)
          else
            params[:frame][:content][:center] = params[:frame][:content][:right]
            params[:frame][:content].delete(:right)                       
          end
        else
          return
        end
        params[:frame][:content].delete(:left)
        params[:frame][:content].delete(:right)
      elsif old_template == "top2_bottom1"
        if new_template == "2rows"
          params[:frame][:content][:top] = params[:frame][:content][:topleft]
          params[:frame][:content][:bottom] = params[:frame][:content][:bottom]
          params[:frame][:content].delete(:topleft)
          params[:frame][:content].delete(:bottom)
        elsif new_template == "2column"
          params[:frame][:content][:left] = params[:frame][:content][:topleft]
          params[:frame][:content][:right] = params[:frame][:content][:topright]
          params[:frame][:content].delete(:topleft)
          params[:frame][:content].delete(:topright)
        else
          return
        end
      elsif old_template == "one_slot"
        if new_template == "2rows"
          params[:frame][:content][:top] = params[:frame][:content][:center]
          params[:frame][:content].delete(:center)
        elsif new_template == "2column"
          params[:frame][:content][:left] = params[:frame][:content][:center]
          params[:frame][:content].delete(:center)
        elsif new_template == "top2_bottom1"
          params[:frame][:content][:topleft] = params[:frame][:content][:center]
          params[:frame][:content].delete(:center)          
        end
      end
    end
  end
end
