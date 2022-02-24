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
