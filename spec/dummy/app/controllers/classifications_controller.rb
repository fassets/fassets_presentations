class ClassificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_classification, :only => [:update, :destroy]

  def create
    classification = Classification.new(params[:classification])
    classification.save
    redirect_to url_for(classification.asset.content) + "/edit"
  end
  def destroy
    @classification.destroy
    redirect_to url_for(@classification.asset.content) + "/edit"
  end
  def update
    if params[:commit] == "Drop"
      destroy()
      return
    end
    @classification.label_ids = params[:labels]
    flash[:notice] = "Updated Classification"
    redirect_to url_for(@classification.asset.content) + "/edit"
  end
  
protected
  def find_classification
     @classification = Classification.find(params[:id])
  end
end
