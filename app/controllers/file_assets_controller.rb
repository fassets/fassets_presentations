class FileAssetsController < AssetsController
  skip_before_filter :authenticate_user!, :only => [:thumb, :preview, :original]
  content_model FileAsset

  def new
    @content = FileAsset.new
    render :template => 'assets/new'
  end
  def create
    @content = FileAsset.new(params['file_asset'])
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    if @content.save
      flash[:notice] = "Created new asset!"
      redirect_to url_for(@content) + "/edit"
    else
      render :action => 'new'
    end
  end
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
