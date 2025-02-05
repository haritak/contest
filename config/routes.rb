require 'sidekiq/web'

Rails.application.routes.draw do
  scope :contest do 
    get 'welcome/index'
    post 'welcome/switch_autonomous_submissions'
    post 'welcome/switch_hide_students'
    post 'welcome/switch_enable_coadmin'
    post 'welcome/switch_shutdown_previews'
    post 'welcome/set_seminar_participation_deadline'

    resources :education_directorates
    resources :school_classes
    resources :school_types
    resources :submission_types
    resources :student_submission_types
    resources :submissions do
      collection do 
        get 'admin_index'
      end
      member do
        post 'make_final'
        post 'unfinalize'
        resource :user_files
        post 'toggle_reviewed'
        patch 'save_review_notes'
      end
    end
    resources :student_submissions do
      collection do 
        get 'admin_index'
        get 'export_xlsx'
        get 'download_exported_xlsx'
      end
      member do
        get 'active_tags', to: "tags#get_active_tags", as: "get_active_tags"
        post 'apply_active_tag', to: "tags#apply_active_tag", as: "apply_active_tag"
        post 'apply_specific_tag/:specific_tag_id', to: "tags#apply_specific_tag", as: "apply_specific_tag"
        delete 'delete_selected_tag/:ssu_tag_id', to: "tags#delete_selected_tag", as: "delete_selected_tag"
        post 'make_final'
        post 'unfinalize'
        get 'student_files/show'
        get 'student_files/preview'
        get 'student_files/review_preview(/:thumb_size)', to: "student_files#review_preview", as: "thumbnail"

        post 'toggle_mark_ok'
        post 'toggle_review_public'
        post 'review_edit'
        patch 'review_set_note'
      end
    end
    resources :specialities
    resources :students do
      collection do 
        get 'admin_index'
      end
      member do
        get 'prepare_invitation_link'
        post 'activate_invitation_link'
        post 'deactivate_invitation_link'
        post 'submit_invitation_link'
        get 'new_submission'
        get 'new_submission_type/:student_submission_type', to: 'students#new_typed_submission', as: 'new_typed_submission'
        get 'my_submissions'
        post 'make_final'
        post 'unfinalize'
      end
    end
    resources :teachers do
      collection do 
        get 'admin_index'
      end
      member do
        post 'make_final'
        post 'unfinalize'
        post 'toggle_coadmin'
      end
    end
    resources :people
    resources :schools
    resources :teams do
      collection do 
        get 'admin_index'
        get 'school_approval/:secret_url_part', to: 'teams#school_approval', as: 'school_approval'
        post 'perform_school_approval/:secret_url_part', to: 'teams#perform_school_approval', as: 'perform_school_approval'
        get 'export_xlsx'
        get 'download_exported_xlsx'
      end
      member do
        get 'secretary_show'
        post 'make_final'
        post 'resend_school_approval'
        post 'unfinalize'
      end
    end
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }
    resources :users do
      member do
        post 'make_participation_final'
        post 'unfinalize_participation'
        post 'make_participation_to_seminar_final'
        post 'unfinalize_participation_to_seminar'
        post 'become'
        post 'manualy_confirm'
      end
    end
    resources :invitations
    resources :invited_submissions
    get 'invited/:secret_url_part', to: 'invited_submissions#index', as: 'invited'

    get 'review_student_submissions/index/:student_category/:student_submission_type_id', to: 'review_student_submissions#index', as: "review_index"
    get 'review_student_submissions/show/:student_submission_id', to: 'review_student_submissions#show', as: "review_show"
    get 'review_student_submissions/next', to: 'review_student_submissions#next'
    get 'review_student_submissions/previous', to: 'review_student_submissions#previous'
    get 'review_student_submissions/tag_student_submission/:student_submission_id', to: 'review_student_submissions#tag_student_submission'

    post 'student_files/set_thumbnail_size'
    

    resources :tags do
      member do 
        post 'set_active'
      end
    end
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    # Defines the root path route ("/")
    root "welcome#index"


    authenticate :user, ->(user) { user.is_admin? } do
      mount Sidekiq::Web => '/sidekiq'
      get 'sent_emails/index'
    end
  end
end
