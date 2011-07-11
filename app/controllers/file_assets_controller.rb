class FileAssetsController < AssetsController
  skip_before_filter :authenticate_user!, :only => [:thumb, :preview, :original]
  content_model FileAsset
  
  def thumb
    redirect_to "/public/uploads/#{@content.id}/thumb.#{params[:format]}"
  end
  def preview
    redirect_to "/public/uploads/#{@content.id}/small.#{params[:format]}"
  end
  def original
    redirect_to "/public/uploads/#{@content.id}/original.#{params[:format]}"
  end
end
