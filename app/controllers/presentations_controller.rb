class PresentationsController < AssetsController
  def show
    @presentation = @content
    render :layout => "frame"
  end
  def content_model
    return Presentation
  end
  def copy
    old_presentation = Presentation.find(params[:presentation_id])
    new_presentation = Presentation.create(:title => old_presentation.title, :template => old_presentation.template)
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
end
