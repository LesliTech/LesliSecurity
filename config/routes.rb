=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

LesliGuard::Engine.routes.draw do

    # Dashboard alias
    root to: "dashboards#show"

    # Dashboard management
    resource :dashboard, only: [:show]
    resources :dashboards do
        collection do
            post "list" => :index
            get :options
        end
        scope module: :dashboard do
            resources :components
        end
    end

    # User management
    resources :users, only: [:index, :show, :new, :update] do 

        # extensions to the user methods
        scope module: :user do

            # sessions management
            resources :sessions, only: [:index, :destroy]

            # assign and remove roles to users 
            resources :roles, only: [:index, :create, :destroy]

            # shortcuts
            resources :shortcuts, only: [:index, :create, :update, :destroy]

            # configuration 
            resources :settings, only: [:create]

        end
    end

    # Work with roles and privileges
    resources :roles, only: [:index, :show, :edit, :new, :create] do
        scope module: :role do
            resources :descriptors, only: [:index, :create, :update, :destroy]
            resources :privileges, only: [:index]
            resources :activities
        end
        collection do
            get :options
        end 
    end

    # Descriptor management
    resources :descriptors, only: [:index, :show, :new, :create] do
        scope module: :descriptor do
            resources :privileges, only: [:index, :create, :destroy] 
            #resources :activities
        end
    end
end
