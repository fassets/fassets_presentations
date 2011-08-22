class FramesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_presentation
  before_filter :find_frame, :except => [:new, :create, :sort]
  def create
    if params[:id]
      frame = Frame.find(params[:id]).clone();
      frame.presentation_id = @presentation.id
    else
      frame =  @presentation.frames.build(params[:frame])
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
  def update
    arrange_slots()
    if @frame.update_attributes(params[:frame])
      flash[:notice] = "frame succesfully updated!"
    else
      flash[:error] = "Could not update frame!"
    end
    redirect_to edit_presentation_frame_path(@presentation, @frame)
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
    redirect_to edit_presentation_path(@presentation)
  end

  def sort
    root_frame = @presentation.root_frame
    params[:frame].each_with_index do |id , position|
      frame_id, parent_id = id
      if parent_id == "root"
        parent_id = root_frame.id
      end
      logger.debug("ID:"+frame_id.to_s+"position:"+position.to_s)
      frame = @presentation.frames.find(frame_id)
      frame.update_attribute(:parent_id, parent_id)
      frame.update_attribute(:position, position+1)
    end
    render :nothing => true
  end
protected
  def find_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end
  def find_frame
    @frame = @presentation.frames.find(params[:id])
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
