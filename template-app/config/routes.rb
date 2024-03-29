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
    post 'update_profile', to: 'patients#update_profile'
    post 'update_patient_profile', to: 'patients#update_patient_profile'
    get 'get_patients_list', to: 'patients#get_patients_list'
    put 'patient_profile_photo', to: 'patients#patient_profile_photo'
    get 'patient_detail', to: 'patients#patient_detail'
    get 'current_patient_detail', to: 'patients#current_patient_detail'
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
    put 'update', to: 'doctors#update'
    get 'show', to: 'doctors#show'
    get 'show_doctor', to: 'doctors#show_doctor'
    post 'doctor_profile_image', to: 'doctors#doctor_profile_image'
    post 'upload_documents', to: 'doctors#upload_documents'
    get 'create_admin', to: 'accounts#create_admin'
  end

#<---------------doctor announcement routes----------------------------------------->
  namespace :bx_block_posts do
    post 'create', to: 'announcements#create'
    get 'show', to: 'announcements#show'
    put 'update', to: 'announcements#update'
    delete 'delete', to: 'announcements#delete'    
  end

#<---------------doctor profile routes----------------------------------------->
  namespace :bx_block_profile do
    put 'doctor_profile', to: 'profiles#doctor_profile'
  end
#<---------------doctor availiability routes----------------------------------------->
  namespace :bx_block_calendar do
    post 'create', to: 'availabilities#create'
    get 'show', to: 'availabilities#show'
    get 'doctor_availiablity', to: 'availabilities#doctor_availiablity'
    put 'update', to: 'availabilities#update'
    delete 'delete', to: 'availabilities#delete'
  end

#<---------------doctor clinics routes----------------------------------------->
  namespace :bx_block_address do
    post 'create', to: 'clinics#create'
    get 'show', to: 'clinics#show'
    delete 'delete', to: 'clinics#delete'
    put 'update', to: 'clinics#update'
  end
#<---------------doctor fees management/packages----------------------------------------->
  namespace :bx_block_fee_management do
    post 'create_package', to: 'packages#create_package'
    get 'show_package', to: 'packages#show_package'
    get 'show', to: 'packages#show'
    put 'update_package', to: 'packages#update_package'
    delete 'delete_package', to: 'packages#delete_package'    
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
