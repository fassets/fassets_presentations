class FileAssetsController < AssetsController
  skip_before_filter :authenticate_user!, :only => [:thumb, :preview, :original]

  def thumb
    redirect_to "/public/uploads/#{@content.id}/thumb.#{params[:format]}"
  end
  def preview
    redirect_to "/public/uploads/#{@content.id}/small.#{params[:format]}"
    #render :partial => @content.class.to_s.underscore.pluralize + "/" + @content.media_type.to_s.underscore + "_preview"
  end
  def original
    redirect_to "/public/uploads/#{@content.id}/original.#{params[:format]}"
  end
  def content_model
    return FileAsset
  end
end
