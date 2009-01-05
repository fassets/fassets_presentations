class FacetsController < ApplicationController
  before_filter :login_required
  before_filter :find_catalog
  
  def new
  end
  def create
    @facet = Facet.new(params[:facet])
    @facet.catalog_id = @catalog.id
    if @facet.save
      flash[:notice] = "Facet was successfully created."
      redirect_to edit_catalog_facet_path(@catalog, @facet)
    else
      render :action => 'new'
    end
  end
  def edit
    @facet = @catalog.facets.find(params[:id])
  end
  def update
    @facet = @catalog.facets.find(params[:id])
    if @facet.update_attributes(params[:facet])
      flash[:notice] = "Facet has been updated"
      redirect_to  edit_catalog_facet_path(@catalog, @facet)
    else
      render :action => 'edit'
    end
  end
  def destroy
    @catalog = @catalog.facets.find(params[:id])
    @catalog.destroy
    redirect_to catalog_path(@catalog)
  end
  
  def sort
    params[:tray].each_with_index do |id, position|
      Label.update(id, :position => position+1)
    end
    respond_to do |format|
      format.js {render :nothing  => true}
    end
  end  
protected
  def find_catalog
    @catalog = Catalog.find(params[:catalog_id])
  end
end
