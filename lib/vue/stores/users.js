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
export const useUsers = defineStore("guard.users", {
    state: () => {
        return {
            loading: false,
            search: "",
            order: {
                column: "id",
                direction: "desc"
            },
            index: { 
                pagination: {},
                records: []
            },
            filters :{
                per_page: 15,
                role: null,
                status: 'active'
            },
            roles_options: [],

            user: {
                roles_id: null,
                email: null,
                first_name: null,
                last_name: null,
                telephone: null,
            }
        }
    },
    actions: {

        search(search_string) {
            this.index.pagination.page = 1
            this.search_string = search_string
            this.loading = true
            this.getUsers()
        },

        paginateIndex(page) {
            this.index.pagination.page = page
            this.getUsers()
        },

        sortIndex(column, direction) {
            this.order.column = column
            this.order.direction = direction
            this.getUsers()
        },

        fetchUsers() {

            if (!this.index.pagination?.results > 0) {
                this.loading = true
                this.getUsers()
            }

        },

        getUsers() {
            
            const query_filters = {}

            //Format filters to send them in the query string
            for (const [key, value] of Object.entries(this.filters)) {
                //query_filters[key] = [value]
            }

            this.http.get(
                this.url
                .security("users")
                .search(this.search_string)
                .paginate(this.index.pagination.page, this.filters.per_page)
                .filter(query_filters)
                .order(this.order.column, this.order.direction)
            ).then(result => {
                this.index = result
                this.search_string=""
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        getUser(id=null) {

            // get the profile by default
            let url = this.url.lesli("profile")

            // get an specifick user if id is provided
            if (id) { url = this.url.lesli("users/:id", id) }

            this.http.get(url).then(result => {
                this.user = result
                this.user.password = ""
                this.user.password_confirmation = ""

                this.language = result.locale ? result.locale.value : this.language

                // Backend should return the list of roles ordered by object level permission
                this.role_names = result.roles[0].name
                
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        postUsers() {
            return this.http.post(this.url.admin("users"), {
                user: this.user
            })
        },

        fetchList() {
            this.loading = true
            return this.http.get(this.url.admin("users/list")).then(response => {
                //this.records = response
                this.list = response
            }).catch(error => {
                
            }).finally(() => {
                this.loading = false
            })
        }
        
    }
})
