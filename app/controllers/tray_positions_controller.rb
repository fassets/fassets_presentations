class TrayPositionsController < ApplicationController
  before_filter :login_required
  def destroy
    @tray_position = current_user.tray_positions.find(params[:id])
    @tray_position.destroy
    respond_to do |format|
      format.js
    end
  end
  def sort
    insert_pos = 0
    if params[:tray]
      params[:tray].each_with_index do |id, position|
        if id == "0"
          insert_pos = position + 1;
        else
          TrayPosition.update(id, :position => position+1)          
        end
      end
    end
    render :update do |page|
      if params[:add_asset]
        tp = current_user.tray_positions.find(:first, :conditions => ["asset_id = ?", params[:add_asset].to_i]) 
        puts tp.inspect            
        if tp
          page << %Q{ $("#tray_#{tp.id}").effect("shake"); }
          page << %Q{ $("#tray_0").remove(); }
        else
          tp = TrayPosition.create(:asset_id => params[:add_asset], 
                                   :user_id => current_user.id,  
                                   :position => insert_pos)
          tray_position = render_escaped(:partial => 'shared/tray_position', 
                                         :locals => {:tray_position => tp})
          page << %Q{
            $("#tray_0").replaceWith("#{tray_position}");
            ajaxifyTrayRemoveButtons();
          }
        end
      end
      page << %Q{$("#tray").sortable("refresh");}
    end
  end
end
