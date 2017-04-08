Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/OpenScadpm'

  get 'static_pages/Documentation'

  get 'static_pages/Support'

  root 'static_pages#home'
end
