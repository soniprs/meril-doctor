ActiveAdmin.register AccountBlock::Doctor, as: "Doctor" do

  actions :all, except: [:destroy, :new, :edit]
  menu priority: 2

    index do
      selectable_column
      id_column
      column :first_name
      column :last_name
      column :email
      column :activated
      column :created_at
      actions
    end

    filter :email
    filter :activated
    filter :full_name
    filter :created_at

    show do |f|
     attributes_table do
        row :first_name
        row :last_name
        row :email
        row :full_phone_number
        row :registration_no
        row :registration_council
        row :year
        row :city
        row :specialization
        row :medical_representative_name
        row :representative_contact_no
        row :experience
        row :activated
        row :full_name
        row :pin
        row :created_at
        row :updated_at 
        row :image ,interactive: true do |avatar|
         image_tag(avatar.profile_image,:size =>"200x200") if avatar.profile_image.present?
        end
        row :registration_details do
          div do
            f.registration_details.each do |r|
              div do 
                image_tag url_for(r), size: "200x200"
              end
            end
          end
        end

        row "degree_details" do
          div do
            f.degree_deatils.each do |d|
              div do
                image_tag url_for(d), size: "200x200"
              end
            end
          end
        end

        row :identity_details do
          div do
            f.identity_details.each do |i|
              div do
                image_tag url_for(i), size: "200x200"
              end
            end
          end
        end

        row :clinic_details do
          div do
            f.clinic_details.each do |c|
              div do
                image_tag url_for(c), size: "200x200"
              end
            end
          end
        end

        row :id ,interactive: true do |object|
          object.id
        end
        row :text_size ,interactive: true do |object|
          object.privacy_setting.text_size  if  object.privacy_setting.present?
        end
        row :mode ,interactive: true do |object|
          object.privacy_setting.mode   if  object.privacy_setting.present?
        end
      end
    end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :first_name, :last_name, :email, :full_phone_number, :registration_no, :registration_council, :year, :specialization, :city, :medical_representative_name, :representative_contact_no, :experience, :image, :activated, :full_name, :pin
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :full_phone_number, :registration_no, :registration_council, :year, :specialization, :city, :medical_representative_name, :representative_contact_no, :experience, :image, :activated, :full_name, :pin]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
