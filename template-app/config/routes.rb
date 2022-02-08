Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

   namespace :bx_block_login  do
    post 'patient_login', to: 'patient_logins#patient_login'
    post 'resend_otp', to: 'patient_logins#resend_otp'
   end

   namespace :bx_block_profile do
    post 'create_otp', to: 'patients#create_otp'
    post 'sms_confirm', to: 'patients#sms_confirm'
    post 'patient_create', to: 'patients#patient_create'
   end
 end
