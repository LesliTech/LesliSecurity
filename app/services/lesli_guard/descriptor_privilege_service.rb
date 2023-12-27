module LesliGuard 
    class DescriptorPrivilegeService < Lesli::ApplicationLesliService 

        def index params

            # First we create a pivot table to convert from:
            # controller_id
            # list
            # index
            # show
            # create
            # update
            # destroy
            # to:
            # controller_id | list | index | show | create | update | destroy |
            # so this is more easy to manage by the API clients
            # NOTE: it is necessary to group by controller id so we ger only one
            # row by controller
            privileges_pivot = Lesli::SystemController.joins(:actions)
            .where("lesli_system_controller_actions.deleted_at IS NULL")
            .group(:system_controller_id)
            .select(
                :system_controller_id,
                "MAX(CASE WHEN lesli_system_controller_actions.name = 'list'    THEN lesli_system_controller_actions.id end) AS list_action",
                "MAX(CASE WHEN lesli_system_controller_actions.name = 'index'   THEN lesli_system_controller_actions.id end) AS index_action",
                "MAX(CASE WHEN lesli_system_controller_actions.name = 'show'    THEN lesli_system_controller_actions.id end) AS show_action",
                "MAX(CASE WHEN lesli_system_controller_actions.name = 'create'  THEN lesli_system_controller_actions.id end) AS create_action",
                "MAX(CASE WHEN lesli_system_controller_actions.name = 'update'  THEN lesli_system_controller_actions.id end) AS update_action",
                "MAX(CASE WHEN lesli_system_controller_actions.name = 'destroy' THEN lesli_system_controller_actions.id end) AS destroy_action"
            )

            # We join to the SystemControllers table again to get the controller name
            # IMPORTANT: We dont get the name from the previos SQL query due we dont want to group by the name string
            # then we have to join to the descriptor_privileges table six times (one time for every action, list, index, etc)
            # we have to do that due we need to check which privileges we have activated
            # later in the select statement we get the id for the list action and if the id is not null get true/false if 
            # action is assigned to the descriptor privileges
            # we consider a privilege as active when it has an action assigned and the deleted_at column is null
            # we remove the nulls using "attributes.compact" it is important to remove all the nulls due a null action id
            # means the specific action is not implemented in any application routes, which means there is no view, controller
            # or model defined for that action
            Lesli::SystemController.joins("INNER JOIN (#{privileges_pivot.to_sql}) privileges ON privileges.system_controller_id = lesli_system_controllers.id")
            .joins("left join lesli_descriptor_privileges dp_list  on dp_list.descriptor_id  = #{params[:descriptor_id]} and dp_list.action_id = privileges.list_action")
            .joins("left join lesli_descriptor_privileges dp_index on dp_index.descriptor_id = #{params[:descriptor_id]} and dp_index.action_id = privileges.index_action")
            .joins("left join lesli_descriptor_privileges dp_show  on dp_show.descriptor_id  = #{params[:descriptor_id]} and dp_show.action_id = privileges.show_action")
            .joins("left join lesli_descriptor_privileges dp_create  on dp_create.descriptor_id  = #{params[:descriptor_id]} and dp_create.action_id = privileges.create_action")
            .joins("left join lesli_descriptor_privileges dp_update  on dp_update.descriptor_id  = #{params[:descriptor_id]} and dp_update.action_id = privileges.update_action")
            .joins("left join lesli_descriptor_privileges dp_destroy on dp_destroy.descriptor_id = #{params[:descriptor_id]} and dp_destroy.action_id = privileges.destroy_action")
            .order(:name)
            .select(
                "name as controller",
                "privileges.list_action",
                "case when privileges.list_action is not null then case when dp_list.action_id is null then false else true end end as list_active",

                "privileges.index_action",
                "case when privileges.index_action is not null then case when dp_index.action_id is null or dp_index.deleted_at is not null then false else true end end as index_active",

                "privileges.show_action",
                "case when privileges.show_action is not null then case when dp_show.action_id is null or dp_show.deleted_at is not null then false else true end end as show_active",

                "privileges.create_action",
                "case when privileges.create_action is not null then case when dp_create.action_id is null or dp_create.deleted_at is not null then false else true end end as create_active",

                "privileges.update_action",
                "case when privileges.update_action is not null then case when dp_update.action_id is null or dp_update.deleted_at is not null then false else true end end as update_active",

                "privileges.destroy_action",
                "case when privileges.destroy_action is not null then case when dp_destroy.action_id is null or dp_update.deleted_at is not null then false else true end end as destroy_active",
            ).map do |privilege|
                privilege.attributes.compact
            end
        end
    end
end
