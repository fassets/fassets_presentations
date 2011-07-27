class CatalogsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  before_filter :find_catalog, :except => [:index, :new, :create, :add_asset]
  def index
    @catalogs = Catalog.all
  end
  def show
    @filter = LabelFilter.new(params[:filter])
    @assets = @catalog.assets.filter(@filter)
    @counts = 0
    logger.debug "Flash:"+flash.to_s
  end
  def new
    @catalog = Catalog.new
  end
  def create
    @catalog = Catalog.new(params[:catalog])
    if @catalog.save
      flash[:notice] = "Catalog was successfully created."
      redirect_to catalogs_path
    else
      if params[:catalog][:title].blank?
        flash[:error] = "Catalog could not be created! Title cannot be empty!"
      else
        flash[:error] = "Catalog could not be created!"
      end
      render :template => 'catalogs/index'
    end
  end
  def edit
    @catalog = Catalog.find(params[:id])
  end
  def update
    if params[:catalog][:title].blank?
      flash[:error] = "Catalog could not be updated! Title cannot be empty!"
      redirect_to :back
      return
    end
    if @catalog.update_attributes(params[:catalog])
      redirect_to catalog_path(@catalog)
    else
      render :action => 'edit'
    end
  end
  def destroy
    @catalog.destroy
    flash[:notice] = "Catalog was successfully destroyed."
    redirect_to root_url
  end
  def add_asset
      @catalog = Catalog.find(params[:catalog_id])
      if Classification.where(:catalog_id => params[:catalog_id], :asset_id => params[:asset_id]).exists?
        flash[:error] = "Asset already in catalog!"
        redirect_to :back
        return
      end
      classification = Classification.new(:catalog_id => params[:catalog_id], :asset_id => params[:asset_id]);
      if classification.save
        flash[:notice] = "Asset successfully added to catalog"
      else
        flash[:error] = "Could not add asset to catalog"
      end
      redirect_to catalog_path(@catalog)
  end
protected
  def find_catalog
    @catalog = Catalog.find(params[:id])
  end
end
