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
    end
    respond_to do |format|
      if slide.save
        format.html {redirect_to edit_presentation_slide_path(@presentation, slide)}
        format.json {render :status => :created, :json => slide.to_json}
      else
        flash[:error] = "Title cannot be empty"
        format.html {redirect_to edit_presentation_path(@presentation)}
      end
    end
  end
  def update
    @slide.update_attributes(params[:slide])
    redirect_to edit_presentation_slide_path(@presentation, @slide)
  end
  def show
    redirect_to presentation_path(@presentation) + "##{@slide.position}"
  end
  def destroy
    @slide.destroy
    redirect_to edit_presentation_path(@presentation)
  end

  def sort
    params[:slide].each_with_index do |id, position|
      slide = @presentation.slides.find(id)
      slide.update_attribute(:position, position+1)
    end
    render :text => 'ok'
  end
protected
  def find_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end
  def find_slide
    @slide = @presentation.slides.find(params[:id])
  end
end
