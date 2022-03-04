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


    show do |f|
     attributes_table do
        row :first_name
        row :last_name
        row :email
        row :full_phone_number
        row :weight
        row :blood_group
        row :city
        row :aadhar_no
        row :health_id
        row :ayushman_bharat_id
        row :disease
        row :activated
        row :full_name
        row :pin
        row :created_at
        row :updated_at 
        row :image ,interactive: true do |avatar|
         image_tag(avatar.profile_photo,:size =>"200x200") if avatar.profile_photo.present?
        end
        row :id ,interactive: true do |object|
          object.id
        end
        row :mode ,interactive: true do |object|
          object.privacy_setting.mode  if  object.privacy_setting.present?
        end
        row :language ,interactive: true do |object|
          object.privacy_setting.language   if  object.privacy_setting.present?
        end
      end
    end
     
   

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
