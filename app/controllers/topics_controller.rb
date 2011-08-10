class TopicsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_presentation
  def create
    logger.debug(params)
    if params[:parent_id]
      parent = Topic.find(params[:parent_id])
      topic = Topic.create(:title => params[:topic][:title], :presentation_id => params[:presentation_id])
      topic.move_to_child_of(parent)
    else
      root = Topic.create(:title => @presentation.name, :presentation_id => params[:presentation_id])
      root.save
      topic = Topic.create(:title => params[:topic][:title], :presentation_id => params[:presentation_id], :parent_id => root.id)
    end
    respond_to do |format|
      if topic.save
        flash[:notice] = "Topic succesfully created!"
        format.html {redirect_to :back}
        format.json {render :status => :created, :json => topic.to_json}
      else
        flash[:error] = "Title of Topic cannot be empty"
        format.html {redirect_to :back}
      end
    end
  end
  def sort
    reorder_children(params[:topic])
    render :nothing => true
  end
 def reorder_children(ordered_ids)
    ordered_ids = ordered_ids.map(&:to_i)
    logger.debug("ordered_ids:"+ordered_ids.to_s)
    #current_ids = children.map(&:id)
    current_ids = @presentation.topics.map(&:id)
    logger.debug("current_ids:"+current_ids.to_s)
    unless current_ids - ordered_ids == [] && ordered_ids - current_ids == []
      raise ArgumentError, "Not ordering the same ids that I have as children. My children: #{current_ids.join(", ")}. Your list: #{ordered_ids.join(", ")}. Difference: #{(current_ids - ordered_ids).join(', ')} / #{(ordered_ids - current_ids).join(', ')}" 
    end
    j = 0
    for new_id in ordered_ids
      old_id = current_ids[j]
      if new_id == old_id
        j += 1
      else
        Topic.find(new_id).move_to_left_of(old_id)
        current_ids.delete(new_id)
      end
    end
  end

protected
  def find_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end
end
