class SlidesController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_presentation
  before_filter :find_slide, :except => [:new, :create]
  def create
    slide =  @presentation.slides.build(params[:slide])
    if slide.save
      redirect_to edit_presentation_slide_path(@presentation, slide) 
    else
      edit_presentation_path(@presentation)
    end
  end
  def update
    @slide.update_attributes(params[:slide])
    redirect_to edit_presentation_slide_path(@presentation, @slide) 
  end
  def show
    template_path = File.join(TEMPLATE_PATH, @presentation.template).to_s
    outer_template = File.join(template_path, "outer.html.haml").to_s
    inner_template = File.join(template_path, "#{@slide.template}.html.haml").to_s
    
    @inner_template = render_to_string(:file => inner_template)
                                        
    render :file => outer_template,
           :layout => "slide"
  end
  def destroy
    @slide.destroy
    redirect_to edit_presentation_path(@presentation)
  end
protected
  def find_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end
  def find_slide
    @slide = @presentation.slides.find(params[:id])
  end
end
