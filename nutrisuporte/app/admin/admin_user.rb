ActiveAdmin.register AdminUser do     

  actions :edit, :update
  batch_actions = false
  index do                            
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  filter :email                       

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions                         
  end          

  controller do
    def redirect_to_edit
      redirect_to edit_admin_admin_user_path(current_admin_user), :flash => flash
    end
    alias_method :index, :redirect_to_edit
    alias_method :show,  :redirect_to_edit
    alias_method :new, :redirect_to_edit
  end

end                                   
