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
import { useUser } from "LesliGuard/stores/user"


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
        users: i18n.t("lesli_guard.users")
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

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> 
                    {{ translations.guard.users.column_email }}
                    <span class="is-danger">*</span>
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="user_email" v-model="storeUser.user.email" required="required" type="email" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> 
                    {{ translations.guard.users.column_first_name }}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="first_name" v-model="storeUser.user.first_name" type="text" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">
                    {{ translations.guard.users.column_last_name }}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="last_name" v-model="storeUser.user.last_name" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">
                    {{ translations.guard.users.column_alias }}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="user_alias" v-model="storeUser.user.alias" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">
                    {{ translations.guard.users.column_telephone }}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="user_number" v-model="storeUser.user.telephone" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">
                    {{ translations.guard.users.column_title }}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="user_title" v-model="storeUser.user.detail_attributes.title" class="input">
                    </div>
                </div>
            </div>
        </div>
        <div class="field is-horizontal">
            <div class="field-label is-normal">
            </div>
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
