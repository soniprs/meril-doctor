Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #<---------------patient Routes----------------------------------------->
   namespace :bx_block_login  do
    # post 'patient_login', to: 'patient_logins#patient_login'
    get 'send_otp', to: 'patient_logins#send_otp'
    get 'verify_otp', to: 'patient_logins#verify_otp'

   end

   namespace :account_block do
    post 'create_otp', to: 'patients#create_otp'
    post 'verify_otp', to: 'patients#verify_otp'
    post 'patient_create', to: 'patients#patient_create'
    put 'update_profile', to: 'patients#update_profile'
    get 'get_patients_list', to: 'patients#get_patients_list'
    put 'patient_profile_photo', to: 'patients#patient_profile_photo'
    get 'patient_detail', to: 'patients#patient_detail'
    delete 'delete_patient', to: 'patients#delete_patient'
   end
  
  # <----------Doctor Routes-------------------------------------->
  namespace :bx_block_login  do
    # post 'doctor_login', to: 'doctor_logins#doctor_login'
    get 'send_sms_otp', to: 'doctor_logins#send_sms_otp'
    get 'verify_doctor_otp', to: 'doctor_logins#verify_otp'
  end

  namespace :account_block do
    post 'create_otp_doctor', to: 'doctors#create_otp_doctor'
    post 'doctor_verify_otp', to: 'doctors#doctor_verify_otp'
    post 'doctor_create', to: 'doctors#doctor_create'
    put 'update_doctor', to: 'doctors#update_doctor'
    get 'show', to: 'doctors#show'
    post 'doctor_profile_image', to: 'doctors#doctor_profile_image'
    post 'upload_documents', to: 'doctors#upload_documents'
  end

  namespace :bx_block_posts do
    post 'create', to: 'announcements#create'
    get 'show', to: 'announcements#show'
    put 'update', to: 'announcements#update'
    delete 'delete', to: 'announcements#delete'    
  end

#<---------------search doctor routes----------------------------------------->
  namespace :account_block do
    get 'search_doctor', to: 'searchs#search_doctor'
    get 'search_doctor_categorywise', to: 'searchs#search_doctor_categorywise'
  end

  #<---------------family member routes----------------------------------------->
  namespace :account_block do
    post 'create_family_member', to: 'family_members#create_family_member' 
    get 'get_family_member_list', to: 'family_members#get_family_member_list'
    delete 'delete_family_member', to: 'family_members#delete_family_member'
    put 'update_family_member', to: 'family_members#update_family_member'
    put 'upload_family_member_photo', to: 'family_members#upload_family_member_photo'
  end

  #<---------------allergy routes----------------------------------------->
  namespace :bx_block_custom_form do
    post 'create_allergy', to: 'allergies#create_allergy' 
    get 'search_allergy', to: 'allergies#search_allergy'
    delete 'delete_allergy', to: 'allergies#delete_allergy'
    put 'update_allergy', to: 'allergies#update_allergy'
    get 'get_allergies_list', to: 'allergies#get_allergies_list'
  end

end
