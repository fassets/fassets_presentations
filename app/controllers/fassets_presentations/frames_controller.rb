module FassetsPresentations
  class FramesController < ApplicationController
    include AssetsHelper
    include FramesHelper
    before_filter :authenticate_user!, :except => [:show]
    before_filter :find_presentation, :except => [:markup_preview]
    before_filter :find_frame, :except => [:new, :create, :sort, :markup_preview]
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
      else
        is_root_frame = false
      end
      render :template => "fassets_presentations/frames/edit", :locals => {:is_root_frame => is_root_frame}
    end
    def edit_wysiwyg
      if @frame.parent == nil
        is_root_frame = true
      else
        is_root_frame = false
      end
      render :template => "fassets_presentations/frames/edit_wysiwyg", :locals => {:is_root_frame => is_root_frame}      
    end
    def update
      arrange_slots()
      if @frame.update_attributes(params[:frame])
        flash[:notice] = "frame succesfully updated!"
      else
        flash[:error] = "Could not update frame!"
      end
      redirect_to edit_presentation_frame_path(@presentation, @frame)
    end
    def update_wysiwyg
      params[:frame][:content].each do |slot_name, value|
        params[:frame][:content][slot_name][:markup] = html_to_markdown(params[:frame][:content][slot_name][:markup])
        logger.debug("Markdown"+params[:frame][:content][slot_name][:markup])
      end
      arrange_slots()
      if @frame.update_attributes(params[:frame])
        flash[:notice] = "frame succesfully updated!"
      else
        flash[:error] = "Could not update frame!"
      end
      redirect_to edit_wysiwyg_presentation_frame_path(@presentation, @frame)
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
      render :inline => Kramdown::Document.new(params["markup"]).to_html
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
      if old_template == "2rows"
        if new_template == "2column"
          params[:frame][:content][:left] = params[:frame][:content][:top]
          params[:frame][:content][:right] = params[:frame][:content][:bottom]
        elsif new_template == "top2_bottom1"
          params[:frame][:content][:topleft] = params[:frame][:content][:top]
          params[:frame][:content][:bottom] = params[:frame][:content][:bottom]
        else
          return
        end
        params[:frame][:content].delete(:top)
        params[:frame][:content].delete(:bottom)
      elsif old_template == "2column"
        if new_template == "2rows"
          params[:frame][:content][:top] = params[:frame][:content][:left]
          params[:frame][:content][:bottom] = params[:frame][:content][:right]
        elsif new_template == "top2_bottom1"
          params[:frame][:content][:topleft] = params[:frame][:content][:left]
          params[:frame][:content][:topright] = params[:frame][:content][:right]
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
      end
    end
  end
end
