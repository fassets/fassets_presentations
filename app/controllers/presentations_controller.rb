class PresentationsController < AssetsController
  def show
    @presentation = @content
    render :layout => "frame"
  end
  def content_model
    return Presentation
  end

end
