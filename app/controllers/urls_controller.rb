class UrlsController < AssetsController
  content_model Url

  def new
    @content = Url.new
    render :template => 'assets/new'
  end 
  def show
    redirect_to @content.url
  end
end
