ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :integer_id, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :username, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip
  #
  # or
  #
  # permit_params do
  #   permitted = [:integer_id, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :username, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
