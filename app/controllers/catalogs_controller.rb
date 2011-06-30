class CatalogsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  before_filter :find_catalog, :except => [:index, :new, :create]
  def index
    @catalogs = Catalog.all
  end
  def show
    @filter = LabelFilter.new(params[:filter])
    @assets = @catalog.assets.filter(@filter)
    @counts = 0
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
      render :action => 'new'
    end
  end
  def edit
    @catalog = Catalog.find(params[:id])
  end
  def update
    if @catalog.update_attributes(params[:catalog])
      redirect_to catalog_path(@catalog)
    else
      render :action => 'edit'
    end
  end
  def destroy
    @catalog.destroy
    redirect_to root_url
  end
protected
  def find_catalog
    @catalog = Catalog.find(params[:id])
  end
end
