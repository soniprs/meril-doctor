ActiveAdmin.register AccountBlock::Patient, as: "Patient"  do

  actions :all, except: [:destroy, :new, :edit]
   menu priority: 1

    index do
      selectable_column
      id_column
      column :full_name
      column :full_phone_number
      column :activated
      column :created_at
      actions
    end

    filter :full_phone_number
    filter :activated
    filter :full_name
    filter :created_at

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :first_name, :last_name, :email_id, :full_phone_number, :date_of_birth, :gender, :weight, :blood_group, :city, :aadhar_no, :health_id, :ayushman_bharat_id, :disease, :activated, :full_name, :pin, :location
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email_id, :full_phone_number, :date_of_birth, :gender, :weight, :blood_group, :city, :aadhar_no, :health_id, :ayushman_bharat_id, :disease, :activated, :full_name, :pin, :location]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
