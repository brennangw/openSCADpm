Rails.application.routes.draw do

  root 'static_pages#home'

  get  '/openscadpm',    to: 'static_pages#OpenScadpm'

  get  '/documentation',    to: 'static_pages#Documentation'

  get  '/support',    to: 'static_pages#Support'

end
