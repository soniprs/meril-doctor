Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

   namespace :bx_block_login  do
    post 'patient_login', to: 'patient_logins#patient_login'
    post 'resend_otp', to: 'patient_logins#resend_otp'

    post 'doctor_login', to: 'doctor_logins#doctor_login'
    post 'resend_otp_doctor', to: 'doctor_logins#resend_otp_doctor'
   end

   namespace :account_block do
    post 'create_otp_doctor', to: 'doctors#create_otp_doctor'
    post 'doctor_verify_otp', to: 'doctors#doctor_verify_otp'
    post 'doctor_create', to: 'doctors#doctor_create'
    put 'update_doctor', to: 'doctors#update_doctor'

    post 'create_otp', to: 'patients#create_otp'
    post 'verify_otp', to: 'patients#verify_otp'
    post 'patient_create', to: 'patients#patient_create'
    get 'search_doctor', to: 'patients#search_doctor'
   end
 end
