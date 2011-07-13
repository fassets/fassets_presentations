class PresentationsController < AssetsController
  content_model Presentation

  def show
    @presentation = @content
    render :layout => "slide"
  end
  def index
    @presentation = @content
    render :layout => "slide"
  end
  def new
    @content = Presentation.new
    render :template => 'assets/new'
  end
end
