<script setup>
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


// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from "vue-router"


// · import lesli stores
import { useUsers } from "LesliSecurity/vue/stores/users"


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")


// · implement stores
const storeUsers = useUsers()


// · translations
const translations = {
    lesli: {
        shared: i18n.t("lesli.shared")
    },
    guard: {
        users: i18n.t("lesli_security.users")
    },
    core: {
        users: {},
        roles: {},
        shared: {}
    },
    
}


// ·
const columns = [{
    field: "id",
    label: "ID",
    sort: true
}, {
    field: "fullname",
    label: translations.guard.users.table_header_name,
    sort: true
}, {
    field: "email",
    label: translations.guard.users.table_header_email,
    sort: true
}, {
    field: "rolenames",
    label: translations.guard.users.table_header_roles,
    sort: true
}, {
    field: "active",
    label: translations.guard.users.table_header_status,
    sort: true,
    custom: true
}, {
    field: "current_sign_in_at_string",
    label: translations.guard.users.table_header_last_sign_in,
    sort: true
}]


// ·
const selection = ref()


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "lesli/users",
    },
    defaultRole: {
        type: String,
        required: false,
        default: "",
    }
})


// · initializing
onMounted(() => {
    storeUsers.fetchUsers()
})


//
function showUser(user) {
    router.push(url.root(props.appMountPath+`/${user.id}`).s)
}
</script>
<template>
    <lesli-application-container>
        <lesli-header :title="translations.guard.users.view_title + ' (' + storeUsers.index.pagination.total + ')' ">
            <lesli-button solid icon="add" :to="url.root(props.appMountPath+`/new`)">
                {{ translations.lesli.shared.button_add_new }}
            </lesli-button>
            <lesli-button
                icon="refresh"
                :loading="storeUsers.loading"
                @click="storeUsers.getUsers()">
                {{ translations.lesli.shared.button_reload }}
            </lesli-button>
        </lesli-header>

        <lesli-toolbar>
        </lesli-toolbar>
        <!--
        <lesli-toolbar 
            @search="storeUsers.search"
            :search-placeholder="translations.core.users.view_toolbar_filter_placeholder_search">
            <lesli-select :options="[{
                    label: translations.core.users.view_toolbar_filter_placeholder_all_users,
                    value: null
                }, {
                    label: translations.core.users.view_toolbar_filter_placeholder_active_users,
                    value: 'active'
                }, {
                    label: translations.core.users.view_toolbar_filter_placeholder_inactive_users,
                    value: 'inactive'
                }]"
                v-model="storeUsers.filters.status"
                @change="storeUsers.fetchIndex()">
            </lesli-select> 
            <lesli-select :options="storeUsers.roles_options"
                v-model="storeUsers.filters.role"
                @change="storeUsers.fetchIndex()">
            </lesli-select> 
        </lesli-toolbar>
        -->

        <lesli-table
            :loading="storeUsers.loading"
            :columns="columns"
            :records="storeUsers.index.records"
            :pagination="storeUsers.index.pagination"
            :link="(user) => url.security('users/:id', user.id)"
            @paginate="storeUsers.paginateIndex"
            @sort="storeUsers.sortIndex">

            <template #active="{ value }">
                <span class="tag is-success" v-if="value">
                    {{ translations.lesli.shared.view_status_active }}
                </span>
                <span class="tag is-warning" v-if="!value">
                    {{ translations.core.shared.view_status_inactive }}
                </span>
            </template>

            <template #options="{ record, value }">
                <a class="dropdown-item" @click="storeUsers.doLogout(record.id)">
                    <span class="material-icons">
                        logout
                    </span>
                    <span>
                        {{ translations.core.users.view_btn_logout }}
                    </span>
                </a>
                <a class="dropdown-item" @click="storeUsers.doLock(record.id)">
                    <span class="material-icons">
                        lock
                    </span>
                    <span>
                        {{ translations.core.users.view_btn_revoke_access }}
                    </span>
                </a>
            </template>
        </lesli-table>
    </lesli-application-container>
</template>
