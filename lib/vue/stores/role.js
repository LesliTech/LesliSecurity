/*
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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"
import { useRouter } from "vue-router"


// · initialize/inject plugins
const router = useRouter()


// · 
export const useRole = defineStore("guard.role", {
    state: () => {
        return {
            loading: false,
            router: useRouter(),
            role: {
                name: ""
            },

            options: {},
            descriptors: [],
            descriptorsCustom: [],
            descriptorSearchString: '',

            privileges: [],
        }
    },
    actions: {

        getRole(id) {
            this.loading = true
            this.http.get(this.url.security("roles/:id", id)).then(result => {
                this.role = result
                this.getDescriptors()
                this.loading = false
            })
        },

        postRole() {
            this.role.loading = true
            this.http.post(this.url.security("roles"), this.role).then(result => {
                //msg.success(translations.core.roles.messages_success_role_created_successfully)
                this.router.push(this.url.security("roles/:id/edit", result.id).s)
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.role.loading = false
            })
        },

        putRole() {
            this.role.loading = true
            this.http.put(this.url.admin("roles/:id", this.role.id), this.role).then(result => {
                this.msg.success(I18n.t('core.roles.messages_success_role_successfully_updated'))
            }).finally(() => {
                this.role.loading = false
            })
        },

        searchDescriptors(string) {
            this.descriptorSearchString = string
            this.getDescriptors()
        },

        getDescriptors() {

            let url = this.url.security("roles/:id/descriptors", this.role.id)

            if (this.descriptorSearchString != '') {
                url = url.search(this.descriptorSearchString)
            }

            this.http.get(url).then(descriptors => {
                this.descriptors = descriptors
            })
        },

        postDescriptor(descriptor) {
            this.http.post(this.url.security("roles/:id/descriptors", this.role.id), {
                role_descriptor: {
                    id: descriptor.id
                }
            })
        },

        deleteDescriptor(descriptor) {

            this.http.delete(this.url.security("roles/:id/descriptors/:descriptor_id", {
                id: this.role.id,
                descriptor_id: descriptor.id
            })).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        },

        getPrivileges() {

            let url = this.url.security("roles/:id/privileges", this.role.id)

            this.http.get(url).then(descriptors => {
                this.privileges = descriptors
            }).catch(error => {
                console.log(error)
            })
        },
        updatePrivilege(descriptor) {
            this.http.put(this.url.security("roles/:id/descriptors/:descriptor_id", {
                id: this.role.id,
                descriptor_id: descriptor.id
            }), {
                role_descriptor: {
                    id: descriptor.id,
                    plist: descriptor.plist,
                    pindex: descriptor.pindex,
                    pshow: descriptor.pshow,
                    pcreate: descriptor.pcreate,
                    pupdate: descriptor.pupdate,
                    pdestroy: descriptor.pdestroy,
                }
            })            
        },

        getOptions() {
            this.http.get(this.url.security("roles/options")).then(result => {
                this.options = result
            })
        }, 
        /**
         * @description This action is used to sort the results
         */
        sortIndex(column, direction) {
            this.order.column = column
            this.order.direction = direction
            this.fetch()
        },
        /**
         * @description This action is used to search
         * @param {string} search_string 
         */
        search(search_string) {
            this.search_string = search_string
            this.fetch()
        },
        /**
         * @description This action is used to delete a role
         * @param {Integer} role_id id of the role to be deleted 
         */
        deleteRole(role_id){            
            this.http.delete(this.url.admin('roles/:id', {id: role_id})).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.fetch()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to fetch activity logs from a role
         */
        fetchLogs(){
            this.loading = true
            this.http.get(this.url.admin('roles/:id/activities', {id: this.role.id})).then(result => {
                this.role_activities = result.activities             
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })     
        }
    }
})
