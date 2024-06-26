module LesliSecurity
    class UsersController < Lesli::ApplicationLesliController
        before_action :set_user, only: [
            :show,
            :update,
            :destroy,
            :requestpassword,
            :passwordreset,
            :revokeaccess,
            :logout
        ]

        # GET /users/list
        def list
            respond_to do |format|
                format.json { 
                    respond_with_successful(UserService.new("current_user").list(query, params)) 
                }
            end
        end

        # GET /users
        def index
            respond_to do |format|
                format.html 
                format.json {
                    return respond_with_pagination(UserService.new(current_user, query).index(params))
                }
            end
        end
    
        def show
            respond_to do |format|
                format.html
                format.json {
                    return respond_with_not_found unless @user.found?
                    return respond_with_successful(@user.show)
                }
            end
        end

        def create
            user = UserService.new(current_user).create(user_params)
            if user.successful?
                respond_with_successful(user.result)
            else 
                respond_with_error("Error creating user", user.errors)
            end
        end
    
        def update

            # check if the user trully exists
            return respond_with_not_found unless @user.found?

            # update the user information
            @user.update(user_params)

            # check saved
            if @user.successful?
                respond_with_successful(@user.result)
            else 
                respond_with_error(@user.errors)
            end
        end
    
        def destroy
            return respond_with_not_found unless @user
    
            # get the user found in the UserServices
            user = @user.result
    
            if user.delete
                current_user.logs.create({ title: "deleted_user", description: "by_user_id: #{ current_user.email }" })
                respond_with_successful()
              else
                respond_with_error(user.errors.full_messages.to_sentence)
            end
        end
    
        # Force the user to update his password
        def requestpassword
            if @user.request_password
                respond_with_successful
            else 
                respond_with_error
            end
        end
    
        # Reset password (generate random)
        def passwordreset
    
            pass = @user.password_reset
    
            if pass
                respond_with_successful(pass)
            else 
                respond_with_error
            end
        end
    
        # this method is going to close all the open user sessions
        def logout
            if @user.logout
                respond_with_successful
            else 
                respond_with_error
            end
        end
    
        # Remove all user access 
        def revokeaccess
            if @user.revoke_access
                respond_with_successful
            else 
                respond_with_error
            end
        end
    
        def become
    
            # always should be disabled
            if Rails.configuration.lesli.dig(:security, :enable_becoming) != true
                return respond_with_unauthorized
            end
    
            # Allow only sysadmin to become as user
            return respond_with_unauthorized if current_user.email != Rails.application.config.lesli.dig(:account, :user, :email) # sysadmin user
    
            # Search for desire user
            becoming_user = User.find(params[:id])
    
            # Return an error if user does not exist
            return respond_with_error I18n.t("core.shared.messages_warning_user_not_found") if becoming_user.blank?
    
            # Extrictly save a log when becoming
            current_user.activities.create!({
                users_id: becoming_user.id,
                owner_id: current_user.id,
                description: "#{current_user.full_name} -> #{becoming_user.full_name}",
                category: "action_become"
            })
    
            # Sign in as the becoming user
            sign_in(:user, becoming_user)
    
            # Create a new session for the becoming user
            becoming_session = becoming_user.sessions.create({
                :user_agent => get_user_agent,
                :user_remote => request.remote_ip,
                :session_source => "become_session",
                :last_used_at => LC::Date.now,
                :expiration_at => 60.minutes.from_now
            })
    
            # assign the session of the becomer user to the becoming user
            session[:user_session_id] = becoming_session[:id]
    
            # Response successful
            respond_with_successful([current_user, becoming_user])
    
        end
    
        def options
            respond_with_successful({
                #regions: current_user.account.locations.where(level: "region"),
                salutations: User::Detail.salutations.map {|k, v| {value: k, text: v}},
                locales: Rails.application.config.lesli.dig(:configuration, :locales_available),
                mfa_methods: Rails.application.config.lesli.dig(:configuration, :mfa_methods)
            })
        end
    
        private
    
        # @return [void]
        # @description Sets the requested user based on the current_users's account
        # @example
        #     # Executing this method from a controller action:
        #     set_user
        #     puts @user
        #     # This will either display nil or an instance of Account::User
        def set_user
            @user = UserService.new(current_user).find(params[:id])
        end
    
        def user_params
            params.require(:user).permit(
                :active,
                :email,
                :alias,
                :roles_id,
                :first_name,
                :last_name,
                :telephone,
                detail_attributes: [
                    :title,
                    :salutation,
                    :address,
                    :work_city,
                    :work_region,
                    :work_address
                ]
            )
        end
    end
end
