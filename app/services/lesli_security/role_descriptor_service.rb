module LesliSecurity
    class RoleDescriptorService < Lesli::ApplicationLesliService

        def index role

            # Left join to the role power table, so we can get the records
            # from the assigned descriptors and the available descriptors
            sanitized_role_power_join = ActiveRecord::Base.sanitize_sql([%(
                left join lesli_role_powers 
                on lesli_role_powers.descriptor_id = lesli_descriptors.id 
                and lesli_role_powers.role_id = ?
            ), role.id])

            current_user.account.descriptors
            .where.not(:name => "owner")
            .joins(sanitized_role_power_join)
            .select(
                "coalesce(lesli_role_powers.descriptor_id, lesli_descriptors.id) as id", 
                "lesli_descriptors.name as name",
                "lesli_descriptors.description as description",
                # we take a descriptor as active if it is already in the role power table
                # to validate this we use the following logic:
                #   if the role power is not deleted (deleted_at column must be null)
                #   and the descriptor_id is not null in the role power table
                "case when lesli_role_powers.deleted_at is null and lesli_role_powers.id is not null then true else false end as active"
            )
        end

        def privileges role

            # Inner join the role power table with the descriptors
            # so we get only the descriptors that are assigned to the specific role
            sanitized_role_power_join = ActiveRecord::Base.sanitize_sql([%(
                inner join lesli_role_powers 
                on lesli_role_powers.descriptor_id = lesli_descriptors.id 
                and lesli_role_powers.deleted_at is null
                and lesli_role_powers.role_id = ?
            ), role.id])

            current_user.account.descriptors
            .where.not(:name => "owner")
            .joins(sanitized_role_power_join)
            .select(
                "coalesce(lesli_role_powers.descriptor_id, lesli_descriptors.id) as id", 
                "lesli_descriptors.name as name", 
                "lesli_role_powers.plist",
                "lesli_role_powers.pindex",
                "lesli_role_powers.pshow",
                "lesli_role_powers.pcreate",
                "lesli_role_powers.pupdate",
                "lesli_role_powers.pdestroy",
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'list'").arel.exists.as("has_list"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'index'").arel.exists.as("has_index"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'show'").arel.exists.as("has_show"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'create'").arel.exists.as("has_create"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'update'").arel.exists.as("has_update"),
                Lesli::Descriptor::Privilege.joins(action: :system_controller).where("lesli_descriptor_privileges.descriptor_id = lesli_descriptors.id and lesli_system_controller_actions.name = 'destroy'").arel.exists.as("has_destroy")
            )
        end
    end
end
