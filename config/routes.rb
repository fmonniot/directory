Directory::Application.routes.draw do
  devise_for :users, path: '/admin/user', controllers: {
      sessions:      'admin/session',
      registrations: 'admin/registrations',
      invitations:   'admin/invitations'
  }

  root 'people#index'

  get 'developer', to: 'static#developer'

  get 'people/confirm_deletion', via: 'people'

  namespace 'api' do
    namespace 'v1' do
      resources :people, only: [:show, :index, :destroy] do
        collection do
          get 'search'
        end
      end
    end
  end

  namespace 'admin' do
    root 'static#index'

    get 'index',     to: redirect('/admin')
    get 'dashboard', to: redirect('/admin')

    get 'users', to: 'users#index'

    resources :people do
      collection do
        get 'page/:page', action: :index
        get 'pending'
      end
    end

    namespace 'statistics' do
      get 'views'

      get 'visitors'
      get 'professions'
    end
  end
end
