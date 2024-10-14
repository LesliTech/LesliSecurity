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
import { onMounted, inject } from "vue"


// · import lesli stores
import { useUser } from "LesliSecurity/vue/stores/user"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeUser = useUser()


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const url = inject("url")


// · 
const translations = {
    guard: {
        users: i18n.t("lesli_security.users")
    },
    lesli: {
        shared: i18n.t("lesli.shared")
    },
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}

</script>
<template>
    <lesli-form flat @submit="storeUser.putUser()">

        <lesli-input horizontal required v-model="storeUser.user.email" :label="translations.guard.users.column_email"></lesli-input>
        <lesli-input horizontal required v-model="storeUser.user.first_name" :label="translations.guard.users.column_first_name"></lesli-input>
        <lesli-input horizontal required v-model="storeUser.user.last_name" :label="translations.guard.users.column_last_name"></lesli-input>
        <lesli-input horizontal required v-model="storeUser.user.alias" :label="translations.guard.users.column_alias"></lesli-input>
        <lesli-input horizontal required v-model="storeUser.user.telephone" :label="translations.guard.users.column_telephone"></lesli-input>
        <lesli-input horizontal required v-model="storeUser.user.detail_attributes.title" :label="translations.guard.users.column_title"></lesli-input>

        <div class="field is-horizontal">
            <div class="field-label is-normal"></div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-button icon="save">
                            {{ translations.lesli.shared.button_save }}
                        </lesli-button>                 
                    </div>
                </div>
            </div>
        </div>
    </lesli-form>
</template>
