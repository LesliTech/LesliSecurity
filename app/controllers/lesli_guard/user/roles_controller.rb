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

module LesliGuard
    class User::RolesController < ApplicationController
        before_action :set_user, only: [:index, :create, :destroy]
        before_action :set_user_role, only: [:destroy]

        # Get the list of assigned roles of the requested user
        # we filter the roles according to the object level permission
        # of the current_user
        def index 
            respond_with_successful(@user.available_roles)
        end

        def create

            # get the role to assign to the user
            role = current_user.account.roles.find(user_role_params[:id])

            unless current_user.can_work_with_role?(role)
                return respond_with_error(I18n.t("core.roles.messages_danger_cannot_assign_level_of_role"))
            end

            # create new role for user if it does not exist
            user_role = @user.result.powers.with_deleted.find_or_create_by({ role: role })

            # if role was soft deleted we need to recover it instead of create a new record
            user_role.recover if user_role.deleted?

            respond_with_successful()

            #User.log_activity_create_user_role(current_user, @user, role)
        end

        # DELETE /user/:user_id/roles/:role_id
        def destroy

            # get the role to assign to the user
            role = current_user.account.roles.find(@user_role.role.id)

            unless current_user.can_work_with_role?(role)
                return respond_with_error(I18n.t("core.roles.messages_danger_cannot_modify_role"))
            end

            @user_role.destroy

            respond_with_successful()

            #User.log_activity_destroy_user_role(current_user, @user, role)
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_user
            @user = UserService.new(current_user).find(params[:user_id])
        end

        def set_user_role
            @user_role = @user.result.powers.find_by(:role_id => params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def user_role_params
            params.require(:user_role).permit(:id)
        end
    end
end
