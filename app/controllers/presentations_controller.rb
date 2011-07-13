class PresentationsController < AssetsController

  def show
    @presentation = @content
    render :layout => "slide"
  end
  def index
    @presentation = @content
    render :layout => "slide"
  end
  def content_model
    return Presentation
  end
  def create
    @content = Presentation.new(params['presentation'])
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    if @content.save
      flash[:notice] = "Created new asset!"
      redirect_to url_for(@content) + "/edit"
    else
      render :action => 'new'
    end
  end
end
