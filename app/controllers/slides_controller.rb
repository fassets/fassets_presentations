class SlidesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_presentation
  before_filter :find_slide, :except => [:new, :create, :sort]
  def create
    if params[:id]
      slide = Slide.find(params[:id]).clone();
      slide.presentation_id = @presentation.id
    else
      slide =  @presentation.slides.build(params[:slide])
      if params[:topic][:topic_id]
        slide.topic_id = params[:topic][:topic_id]
      end
    end
    respond_to do |format|
      if slide.save
        flash[:notice] = "Slide succesfully created!"
        format.html {redirect_to edit_presentation_slide_path(@presentation, slide)}
        format.json {render :status => :created, :json => slide.to_json}
      else
        flash[:error] = "Title of slide cannot be empty"
        format.html {redirect_to edit_presentation_path(@presentation)}
      end
    end
  end
  def update
    arrange_slots()
    if @slide.update_attributes(params[:slide])
      flash[:notice] = "Slide succesfully updated!"
    else
      flash[:error] = "Could not update slide!"
    end
    redirect_to edit_presentation_slide_path(@presentation, @slide)
  end
  def show
    redirect_to presentation_path(@presentation) + "##{@slide.position}"
  end
  def destroy
    if @slide.destroy
      flash[:notice] = "Slide succesfully deleted!"
    else
      flash[:error] = "Could not delete slide!"
    end
    redirect_to edit_presentation_path(@presentation)
  end

  def sort
    topic = @presentation.topics.find(params[:topic_id])
    topic_position = topic.position
    params[:slide].each_with_index do |id, position|
      slide = @presentation.slides.find(id)
      slide.update_attribute(:position, topic_position+position+1)
    end
    render :nothing => true
  end
protected
  def find_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end
  def find_slide
    @slide = @presentation.slides.find(params[:id])
  end
  def arrange_slots
    old_template = @slide.template
    new_template = params[:slide][:template]
    if old_template == "2rows"
      if new_template == "2column"
        params[:slide][:content][:left] = params[:slide][:content][:top]
        params[:slide][:content][:right] = params[:slide][:content][:bottom]
      elsif new_template == "top2_bottom1"
        params[:slide][:content][:topleft] = params[:slide][:content][:top]
        params[:slide][:content][:bottom] = params[:slide][:content][:bottom]
      else
        return         
      end
      params[:slide][:content].delete(:top)
      params[:slide][:content].delete(:bottom)
    elsif old_template == "2column"
      if new_template == "2rows"
        params[:slide][:content][:top] = params[:slide][:content][:left]
        params[:slide][:content][:bottom] = params[:slide][:content][:right]
      elsif new_template == "top2_bottom1"
        params[:slide][:content][:topleft] = params[:slide][:content][:left]
        params[:slide][:content][:topright] = params[:slide][:content][:right]
      else
        return
      end
      params[:slide][:content].delete(:left)
      params[:slide][:content].delete(:right)
    elsif old_template == "top2_bottom1"
      if new_template == "2rows"
        params[:slide][:content][:top] = params[:slide][:content][:topleft]
        params[:slide][:content][:bottom] = params[:slide][:content][:bottom]
        params[:slide][:content].delete(:topleft)
        params[:slide][:content].delete(:bottom)
      elsif new_template == "2column"
        params[:slide][:content][:left] = params[:slide][:content][:topleft]
        params[:slide][:content][:right] = params[:slide][:content][:topright]
        params[:slide][:content].delete(:topleft)
        params[:slide][:content].delete(:topright)
      else
        return
      end      
    end
  end
end
