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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"


// · 
export const useDescriptor = defineStore("guard.descriptor", {
    state: () => {
        return {
            descriptor: {
                loading: false,
                payload: {
                    name: ""
                }
            },
            privileges: [],
            privilegesLoading: false
        }
    },
    actions: {

        getDescriptor(id) {
            this.http.get(this.url.guard("descriptors/:id", id)).then(result => {
                this.descriptor = result
                this.getDescriptorPrivileges()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                
            })
        },

        resetDescriptor() {
        },

        postDescriptor() {
            this.loading = true
            this.http.post(this.url.guard("descriptors"), { 
                descriptor: this.descriptor.payload 
            }).then(result => {
                this.descriptor.payload.id = result.id
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        getDescriptorPrivileges() {
            this.privilegesLoading = true
            this.http.get(this.url.guard("descriptors/:id/privileges", this.descriptor.id)).then(result => {
                this.privileges = result
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.privilegesLoading = false
            })
        },

        // Add privilege to descriptor
        postDescriptorPrivilege(action) {
            this.http.post(this.url.guard("descriptors/:id/privileges", this.descriptor.id), {
                descriptor_privilege: {
                    action_id: action
                }
            }).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        },

        // Add privilege to descriptor
        deleteDescriptorPrivilege(action) {
            this.http.delete(this.url.guard("descriptors/:descriptorId/privileges/:descriptorPrivilegeId", {
                descriptorId: this.descriptor.id,
                descriptorPrivilegeId: action
            })).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        }
    }
})
