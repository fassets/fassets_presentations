module FassetsPresentations
  class PresentationsController < ApplicationController
    before_filter :find_content, :except => [:new, :create, :preview, :markup_preview,:copy]
    def new
      @asset = Asset.new
      @presentation = Presentation.new
      @content = @presentation
      render :template => "fassets_presentations/presentations/new"
    end
    def create
      @content = Presentation.new(params[:presentation])
      @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
      respond_to do |format|
        if @content.save
          classification = Classification.new(:catalog_id => params["classification"]["catalog_id"],:asset_id => @content.asset.id)
          classification.save
          flash[:notice] = "Created new asset!"
          format.json { render :json => [ @content.to_jq_upload ].to_json }
        else
          render :template => 'assets/new'
        end
      end
    end
    def destroy
      flash[:notice] = "Asset has been deleted!"
      @content.destroy
      redirect_to main_app.root_url
    end
    def edit
      render :template => "fassets_presentations/presentations/edit", :locals => {:new => false}
    end
    def show
      @presentation = @content
      render :template => "fassets_presentations/presentations/show", :layout => "layouts/fassets_presentations/frame"
    end
    def update
      if @content.update_attributes(params[:presentation]) and @content.asset.update_attributes(params["asset"])
        flash[:notice] = "Succesfully updated asset!"
        render :nothing => true
      else
        flash[:error] = "Could not update asset!"
        render :nothing => true
      end
    end
    def copy
      old_presentation = Presentation.find(params[:id])
      new_presentation = Presentation.create(:title => old_presentation.title, :template => old_presentation.template)
      new_presentation.asset = Asset.create(:user => current_user, :name => old_presentation.asset.name + "- Copy")
      new_presentation.asset.classifications = old_presentation.asset.classifications
      new_presentation.save
      copy_frames(new_presentation.root_frame, old_presentation.root_frame.children)
      @presentation = new_presentation
      @content = new_presentation
      render :template => "/assets/edit", :layout => false
    end
    def copy_frames(new_parent,frames)
      unless frames.length == 0
        frames.each do |frame|
          copy_frame = frame.clone
          copy_frame.parent = new_parent
          copy_frame.presentation = new_parent.presentation
          copy_frame.save
          copy_frames(copy_frame, frame.children)
        end
      end
    end
    def content_model
      FassetsPresentations::Presentation
    end
protected
    def find_content
      if params[:asset_id]
        content_id = Asset.find(params[:id]).content_id
      else
        content_id = params[:id]
      end
      @content = Presentation.find(content_id)
    end
  end
end
