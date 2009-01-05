class CatalogsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  before_filter :find_catalog, :except => [:index, :new, :create]
  def index
    @catalogs = Catalog.all
  end
  def show
    @filter = LabelFilter.new(params[:filter])
    @assets = @catalog.assets.filter(@filter) 
    @counts = Asset.count_for_labels(@filter)
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
  def destroy
    @catalog.destroy
    redirect_to "/"    
  end
protected
  def find_catalog
    @catalog = Catalog.find(params[:id])
  end
end
