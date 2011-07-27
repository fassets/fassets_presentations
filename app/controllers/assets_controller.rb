class AssetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_content, :except => [:new, :create,:preview]

  def new
    @content = self.content_model.new
    render :template => 'assets/new'
  end
  def create
    logger.debug content_params
    @content = self.content_model.new(content_params)
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    if @content.save
      classification = Classification.new(:catalog_id => params["classification"]["catalog_id"],:asset_id => @content.asset.id)
      classification.save
      flash[:notice] = "Created new asset!"
      redirect_to url_for(@content) + "/edit"
    else
      render :template => 'assets/new'
    end
  end
  def show
    render :template => 'assets/show'
  end
  def edit
    render :template => 'assets/edit'
  end
  def update
    if @content.update_attributes(content_params) and @content.asset.update_attributes(params["asset"])
      flash[:notice] = "Succesfully updated asset!"
      redirect_to url_for(@content) + "/edit"
    else
      flash[:error] = "Could not update asset!"
      render :template => 'assets/edit'
    end
  end
  def destroy
    flash[:notice] = "Asset has been deleted!"
    @content.destroy
    redirect_to root_url
  end
  def preview
    content_model = Asset.find(params[:asset_id]).content_type.constantize
    content_id = Asset.find(params[:asset_id]).content_id
    @content = content_model.find(content_id)
    render :partial => content_model.to_s.underscore.pluralize + "/" + @content.media_type.to_s.underscore + "_preview"
  end

protected
  def content_params
    params[self.content_model.to_s.underscore]
  end
  def find_content
    @content = self.content_model.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    redirect_to root_url
  end
end
