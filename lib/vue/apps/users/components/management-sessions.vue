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
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import vue router composable
import { useRoute } from "vue-router"


// · import lesli stores
import { useUser } from "LesliSecurity/vue/stores/user"


// · implement stores
const storeUser = useUser()


// · initialize/inject plugins
const route = useRoute()


// · 
const translations = {
    users: I18n.t("core.users"),
    shared: i18n.t("lesli.shared")
}


// · 
const columns = [{
    field: 'id',
    label: 'ID'
}, {
    field: 'device',
    label: 'Device'
}, {
    field: 'session_source',
    label: 'Source'
}, {
    field: 'created_at_string',
    label: 'Created at'
}, {
    field: 'expiration_at_string',
    label: 'Expiration at'
}]


// · 
onMounted(() => {
    storeUser.fetchSessions()
})

</script>
<template>
        <lesli-toolbar>
            <lesli-button icon="refresh">
                Reload
            </lesli-button>
        </lesli-toolbar>
        <lesli-table
            :columns="columns"
            :records="storeUser.sessions.records">
            <template #buttons="{ record, value }">
                <lesli-button small danger icon="delete" @click="storeUser.deleteSession(record.id)">
                    {{ translations.shared.button_delete }}
                </lesli-button>
            </template>
        </lesli-table>
</template>
