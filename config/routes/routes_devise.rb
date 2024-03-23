devise_for :administrators, module: 'administrators'

devise_scope :administrator do
  get '/administrators/sign_off', to: 'administrators/sessions#destroy', as: :administrator_sign_out
end
