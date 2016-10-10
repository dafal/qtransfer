Rails.application.routes.draw do
  root 'transfers#new_multiple'
  resources :transfers, only: [:new, :create]
  get 'transfers/new_multiple', to: 'transfers#new_multiple', as: :new_multiple
  get 'transfers/messages_update',to: 'transfers#messages_update'
  get 'transfers/update_message/:id' => 'transfers#update_message'
  get 'transfers/:token' => 'transfers#get_file'
end
