Rails.application.routes.draw do
  
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #require 'sidekiq/web'
  #mount Sidekiq::Web => '/sidekiq'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get 'api/v1/users/identification_number/:identification_number', to: 'api/v1/users#show_by_identification_number'
    post 'api/v1/password_reset/', to: 'password_resets#create'
    patch 'api/v1/password_reset/', to: 'password_resets#update'
    post 'api/v1/confirmation/', to: 'confirmations#create' # endpoint for confirming the email address
    
    # endpoints for getting countries/regions and cities
    get 'api/v1/localities/countries', to: 'api/v1/localities#countries'
    get 'api/v1/localities/:country_code/regions', to: 'api/v1/localities#regions'
    get 'api/v1/localities/:country_code/cities', to: 'api/v1/localities#cities'
    
    
    devise_scope :user do
      post 'api/v1/login_as_another_user/', to: 'sessions#login_as_another_user', as: :login_as_another_user
    end
    namespace :api, defaults: { format: :json } do 
      namespace :v1 do
        concern :destroyable do
          collection do
            delete :destroys
          end
        end
      #ressource course_generalities
      resources :course_generalities, concerns: :destroyable do
        collection do
          get :table_header
        end
      end
      #ressource submissions
      resources :submissions, concerns: :destroyable do
        collection do
          get :table_header
        end
      end
      #resources homeworks
      resources :homeworks, concerns: :destroyable do
        collection do
          get :table_header
        end
      end
      resources :solutions, concerns: :destroyable do
        collection do
          get :table_header
        end
      end
      # ressource message
      resources :messages do
        member do
          post :reply
        end
        member do
          post :restore
        end
      end
      # evaluation resource
      resources :evaluations, concerns: :destroyable do
        collection do
          get :table_header
        end
      end

      resources :decodes, concerns: :destroyable do
        collection do
          get :table_header
        end
      end

      resources :decode_configurations, concerns: :destroyable do
        collection do
          get :table_header
        end
      end

      # course resource
      resources :courses, concerns: :destroyable do
        collection do
          get :table_header
        end
        member do
          post :add_teacher
          delete :remove_teacher
          get :teachers
          patch :set_main_teacher
          patch :remove_main_teacher
        end
      end
        
        # attend_scholastic_period resource
        resources :attend_scholastic_periods, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        # parent resource
        resources :parents, concerns: :destroyable do
          collection do
            get :table_header
          end
        end
        # serve resource
        resources :serves, concerns: :destroyable do
          collection do
            get :table_header
            get :serves_data
          end
        end

        # classroom resource
        resources :classrooms, concerns: :destroyable do
          collection do
            get :table_header
          end
        end
        # class level resource
        resources :class_levels, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :statistics, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :news, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :events, concerns: :destroyable do
          member do
            delete :delete_phases
          end
          collection do
            get :table_header
          end
        end

        resources :news_letters, concerns: :destroyable
        resources :scholastic_periods, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :cycles, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :locals, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :evaluation_types, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :departments, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :jobs, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :profiles, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :students, concerns: :destroyable do
          collection do
            get :table_header
          end
        end
        resources :monitorings, concerns: :destroyable do
          collection do
            put :update_attributes_monitor_of_resources
            patch :update_attributes_monitor_of_resources
          end
        end
        resources :galleries, concerns: :destroyable do
          collection do
            get :table_header
          end
        end
        resources :collaborators, concerns: :destroyable do
          collection do
            get :table_header
          end
        end
        resources :generics, concerns: :destroyable do 
          collection do
            get :fast_links
            get :table_header
            get :principal_speech
          end
        end

        
        resources :contacts, concerns: :destroyable 
        resources :table_descriptions, concerns: :destroyable
        resources :extra_activities, concerns: :destroyable do
          collection do
            get :table_header
          end
          resources :configure_activities
          member do
            post :add_student
            delete :remove_student
            post :manage_office
            #post :manage_events
          end
        end

        resources :attachments, concerns: :destroyable do
          collection do 
            post :add_files
          end
        end


        resources :schools, concerns: :destroyable do
          member do
            patch :update_jsonb
            put :update_jsonb
            post :assign_theme
            delete :remove_theme
          end

          collection do
            get :table_header
            get :categories
            get :cycles
            get :class_levels
            get :specialties
            get :super_school
          end
        end

        resources :users, concerns: :destroyable do
          member do
            post :add_role
            post :remove_role
            get :refresh_token
            get :get_user_roles
            post :create_permissions
            get :permissions
          end
          collection do
            get :get_all_roles
            get :school_preferences
            post :edit_permissions
            get :user_home
          end
        end

        resources :themes, concerns: :destroyable do
          collection do
            get :table_header
          end
        end

        resources :reports, concerns: :destroyable do
          collection do
            get :table_header
          end
        end
        
      end
    end
    

  devise_for :users,
    defaults: { format: :json },
    path: '',
    path_names: {
      sign_in: 'api/v1/login',
      sign_out: 'api/v1/logout',
      registration: 'api/v1/signup',
      #login_as_another_user: 'api/v1/login_as_another_user'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }
  end


  root 'welcome#index'
end
