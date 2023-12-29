module LesliGuard
    class RoleDescriptorService < Lesli::ApplicationLesliService

        def index role
            current_user.account.descriptors
            .where.not(:name => "owner")
            .joins(%(
                left join lesli_role_powers 
                on lesli_role_powers.descriptor_id = lesli_descriptors.id
            )).select(
                "coalesce(lesli_role_powers.descriptor_id, lesli_descriptors.id) as id", 
                "lesli_descriptors.name as name", 
                "lesli_role_powers.power_list",
                "lesli_role_powers.power_index",
                "lesli_role_powers.power_show",
                "lesli_role_powers.power_create",
                "lesli_role_powers.power_update",
                "lesli_role_powers.power_destroy",
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'list'").arel.exists.as("has_list"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'index'").arel.exists.as("has_index"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'show'").arel.exists.as("has_show"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'create'").arel.exists.as("has_create"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'update'").arel.exists.as("has_update"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'destroy'").arel.exists.as("has_destroy")
            )
        end

        def index2 role
            role.powers
            .left_joins(descriptor: :privileges)
            .joins(%(
                inner join lesli_system_controller_actions
                on lesli_system_controller_actions.id = lesli_descriptor_privileges.action_id
            ))
            .joins(%(
                inner join lesli_system_controllers  
                on lesli_system_controllers.id = lesli_system_controller_actions.system_controller_id
            ))
            .select(
                "coalesce(lesli_role_powers.descriptor_id, lesli_descriptors.id) as id", 
                "lesli_descriptors.name as name", 
                "lesli_system_controllers.reference as reference", 
                "lesli_system_controllers.route as controller", 
                "lesli_system_controller_actions.name as action", 
                "lesli_system_controllers.engine as engine", 
                "case when lesli_role_powers.descriptor_id is null then false else true end as active"
            )
        end
    end
end
