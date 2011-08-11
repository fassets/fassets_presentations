class TopicsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_presentation
  def create
    logger.debug(params)
    topic_slide =  Slide.create(:title => params[:topic][:title],:template => params[:slide][:template],:presentation_id => params[:presentation_id],:position => 1)
    topic_slide.save
    unless params[:topic][:parent_id].empty?
      parent = Topic.find(params[:topic][:parent_id])
      topic = parent.children.create(:title => params[:topic][:title], :presentation_id => params[:presentation_id])
    else
      topic = Topic.create(:title => params[:topic][:title], :presentation_id => params[:presentation_id])
    end
    topic.topic_slide = topic_slide.id
    respond_to do |format|
      if topic.save
        flash[:notice] = "Topic succesfully created!"
        format.html {redirect_to edit_presentation_slide_path(@presentation, topic_slide)}
        format.json {render :status => :created, :json => topic.to_json}
      else
        flash[:error] = "Title of Topic cannot be empty"
        format.html {redirect_to :back}
      end
    end
  end
  def sort
    params[:slide].each_with_index do |item, position|
      id, parent = item
      slide = @presentation.slides.find(id)
      unless parent == "root"
        new_parent = Topic.find(parent)
        slide.topic_id = new_parent.id
        slide.save
      end
    end
    params[:topic].each_with_index do |item, position|
      id, parent = item
      topic = @presentation.topics.find(id)
      unless parent == "root"
        new_parent = Topic.find(parent)
        topic.parent = new_parent
      else
        topic.parent = nil
      end
      topic.save
      topic.update_attribute(:position, position+1)
    end
    render :nothing => true
  end

protected
  def find_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end
end
