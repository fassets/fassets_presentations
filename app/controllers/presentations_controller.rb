class PresentationsController < AssetsController
  content_model Presentation

  def show
    @presentation = @content
    render :layout => "slide"
  end
end
