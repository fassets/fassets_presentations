module FassetsPresentations
  class PresentationsController < ApplicationController
    before_filter :find_content, :except => [:new, :create, :preview, :markup_preview,:copy]
    def new
      logger.debug("PresentationsController of FassetsPresentations")
      @asset = Fassets::Application::Asset.new
      logger.debug(Fassets::Application::Asset.new)
      @presentation = FassetsPresentations::Presentation.new
      @content = @presentation
      render :template => "fassets-presentations/presentations/new"
    end
    def create
      @content = FassetsPresentations::Presentation.new(params[:presentation])
      @content.asset = Fassets::Application::Asset.create(:user => current_user, :name => params["asset"]["name"])
      if @content.save
        flash[:notice] = "Created new asset!"
        redirect_to url_for(@content) + "/edit"
      else
        render :template => "fassets-presentations/presentations/new"
      end
    end
    def edit
      render :template => "fassets-presentations/presentations/edit"
    end
    def show
      logger.debug("FassetsPresentations - Show")
      @presentation = @content
      render :template => "fassets-presentations/presentations/show", :layout => "fassets-presentations/layouts/frame"
    end
    def content_model
      return FassetsPresentations::Presentation
    end
    def copy
      old_presentation = FassetsPresentations::Presentation.find(params[:presentation_id])
      new_presentation = FassetsPresentations::Presentation.create(:title => old_presentation.title, :template => old_presentation.template)
      new_presentation.asset = old_presentation.asset.clone
      new_presentation.asset.name = old_presentation.asset.name + " - Copy"
      new_presentation.asset.classifications = old_presentation.asset.classifications
      new_presentation.save
      copy_frames(new_presentation.root_frame, old_presentation.root_frame.children)
      @presentation = new_presentation
      @content = new_presentation
      redirect_to url_for(@content) + "/edit"
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
protected
    def find_content
      if params[:asset_id]
        content_id = Asset.find(params[:id]).content_id
      else
        content_id = params[:id]
      end
      logger.debug(content_id)
      @content = Presentation.find(content_id)
    end
  end
end
