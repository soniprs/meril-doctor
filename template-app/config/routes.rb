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
    get 'search_doctor', to: 'doctors#search_doctor'
    put 'update_doctor', to: 'doctors#update_doctor'
  end
 end
