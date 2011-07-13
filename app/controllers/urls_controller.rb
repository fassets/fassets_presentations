class UrlsController < AssetsController
  content_model Url

  def new
    @content = Url.new
    render :template => 'assets/new'
  end
  def create
    unless params["url"["url"] =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
      flash[:error] = "Entered URL was invalid!"
      redirect_to "/urls/new"
      return
    end
    @content = Url.new(params["url"])
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    if @content.save
      flash[:notice] = "Created new asset!"
      redirect_to url_for(@content) + "/edit"
    else
      render :action => 'new'
    end
  end 
  def show
    redirect_to @content.url
  end
end
