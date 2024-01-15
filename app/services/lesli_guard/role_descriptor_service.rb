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
                "lesli_descriptors.description as description",
                "case when lesli_role_powers.deleted_at is null then true else false end as active"
            )
        end

        def index_with_privileges role
            current_user.account.descriptors
            .where.not(:name => "owner")
            .joins(%(
                right join lesli_role_powers 
                on lesli_role_powers.descriptor_id = lesli_descriptors.id
                and lesli_role_powers.deleted_at is NULL
            )).select(
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
