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
import {onMounted, inject } from "vue"
import { useRouter } from 'vue-router'


// · import lesli stores
import { useDescriptors } from "LesliSecurity/vue/stores/descriptors"


// · initialize/inject plugins
const url = inject("url")


// · 
const storeDescriptors = useDescriptors()


// · 
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        role_descriptors: I18n.t('core.role_descriptors'),
        shared: I18n.t("core.shared")
    }
}


// · 
const columns = [{
    field: "id",
    label: "ID",
    sort: true
}, {
    field: "name",
    label: "Name",
    sort: true
},  {
    field: "privileges_count",
    label: "Privileges",
    align: "center",
    sort: true
}, {
    field: "created_at_date",
    label: "Created at"
}]


// · 
onMounted(() => {
    storeDescriptors.fetchDescriptors()
})

</script>
<template>
    <lesli-application-container>
        <lesli-header title="Role Descriptors">
            <lesli-link solid icon="add" :to="url.security('descriptors/new')">
                Add descriptor
            </lesli-link>
            <lesli-button icon="refresh"
                :loading="storeDescriptors.index.loading"
                @click="storeDescriptors.getDescriptors()">
                Reload
            </lesli-button>
        </lesli-header>

        <lesli-toolbar @search="storeDescriptors.search"></lesli-toolbar>

        <lesli-table
            :link="(descriptor) => url.security('descriptors/:id', descriptor.id)"
            :columns="columns"
            :loading="storeDescriptors.index.loading"
            :records="storeDescriptors.index.records"
            :pagination="storeDescriptors.index.pagination"
            @paginate="storeDescriptors.paginateIndex"
            @sort="storeDescriptors.sortIndex">
        </lesli-table>
    </lesli-application-container>
</template>
