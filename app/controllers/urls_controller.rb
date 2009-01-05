class UrlsController < AssetsController
  content_model Url
  
  def show
    redirect_to @content.url
  end
end
