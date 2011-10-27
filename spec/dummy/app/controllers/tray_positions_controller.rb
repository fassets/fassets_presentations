class TrayPositionsController < ApplicationController
  before_filter :authenticate_user!
  def create
    if current_user.tray_positions.maximum(:position)
      params[:tray_position][:position] = current_user.tray_positions.maximum(:position)+1
    else
      params[:tray_position][:position] = 1
    end
    tp = TrayPosition.new(params[:tray_position])
    tp.clipboard_type.capitalize! if tp.clipboard_type
    tp.save
    redirect_to :back
  end
  def replace
    respond_to do |format|
      if params[:del]
        format.html do
          current_user.tray_positions.find(params[:del]).each do |tp|
#            if !tp.clipboard_type  && (tp.asset.classifications_count || 0) == 0
#              tp.asset.content.destroy
#            else
#              tp.destroy
#            end
            tp.destroy
          end
          flash[:notice] = "Tray has been updated!"
          redirect_to :back
        end
      end
      if params[:tp]
        format.json do
          new_tp = nil
          params[:tp].each_with_index do |id, position|
            if id == "0"
              new_tp = TrayPosition.new(:user_id => current_user.id, :position => position+1)
              if params[:add_type] == 'asset'
                new_tp.asset_id = params[:add_id]
              else
                new_tp.clipboard_id = params[:add_id]
                new_tp.clipboard_type = params[:add_type].capitalize
              end
              new_tp.save
            else
              TrayPosition.update(id, :position => position+1)
            end
          end
          if new_tp
            render :json => new_tp.to_json(:include => :clipboard)
          else
            render :json => {}
          end
        end
      end
      if params["asset_id"] and params["asset_id"] != "undefined"
        unless TrayPosition.where(:user_id => current_user.id, :asset_id => params["asset_id"]).exists?
          if current_user.tray_positions.maximum(:position)
            position = current_user.tray_positions.maximum(:position)+1
          else
            position = 1
          end
          new_tp = TrayPosition.new(:user_id => current_user.id, :asset_id => params["asset_id"],:position => position)
          new_tp.save
        end
      end
      format.html do
        redirect_to :back
      end
    end
  end
end
