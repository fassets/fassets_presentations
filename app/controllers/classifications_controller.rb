class ClassificationsController < ApplicationController
  before_filter :login_required
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
    @classification.update_attributes(params[:classification])
    redirect_to url_for(@classification.asset.content) + "/edit"
  end
  
protected
  def find_classification
     @classification = Classification.find(params[:id])
  end
end
