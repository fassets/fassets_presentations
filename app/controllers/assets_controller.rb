class AssetsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_content, :except => [:new, :create]

  def self.content_model(klass)
    @@content_model = klass
  end
  def new
    @content = @@content_model.new
    render :template => 'assets/new'
  end
  def create
    @content = @@content_model.new(content_params)
    @content.asset.user = current_user
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
    if @content.update_attributes(content_params)
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
