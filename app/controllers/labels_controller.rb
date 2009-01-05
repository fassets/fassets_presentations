class LabelsController < ApplicationController
  before_filter :login_required
  before_filter :find_label, :except => [:create]
  def create
    @label = Label.new(params[:label])
    @label.facet_id = params[:facet_id]
    if @label.save
      flash[:notice] = "Label was successfully created."
    end
    redirect_to edit_catalog_facet_path(params[:catalog_id], params[:facet_id])
  end
  def update
    @label.update_attributes(params[:label])
    redirect_to edit_catalog_facet_path(params[:catalog_id], params[:facet_id])    
  end
protected
  def find_label
    @label = Label.find(params[:id])
  end
end
