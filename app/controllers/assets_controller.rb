class AssetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_content, :except => [:new, :create]

  def self.content_model(klass)
    @@content_model = klass
  end
  def create
    logger.debug content_params
    if content_params.include?("url") # If its a URL-Asset check for valid URL
      unless content_params["url"] =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
        flash[:error] = "Entered URL was invalid!"
        redirect_to "/urls/new"
        return
      end
    end
    @content = @@content_model.new(content_params)
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    if @content.save
      flash[:notice] = "Created new asset!"
      redirect_to url_for(@content) + "/edit"
    else
      render :action => 'new'
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
      render :action => 'edit'
    end
  end
  def destroy
    flash[:notice] = "Asset has been deleted!"
    @content.destroy
    redirect_to root_url
  end

protected
  def content_params
    params[@@content_model.to_s.underscore]
  end
  def find_content
    @content = @@content_model.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    redirect_to root_url
  end
end
