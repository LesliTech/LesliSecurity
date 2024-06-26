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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useRole } from "../../stores/role"
import { useDescriptor } from "../../stores/descriptor"


// · import components
import componentFormRole from "./components/form.vue"
import componentPrivilegeCustom from "./components/privilegeCustom.vue"
import componentPrivilegeStandard from "./components/privilegeStandard.vue"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · 
const editor = ref('standard')


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "guard/roles",
    }
})


// · 
onMounted(() => {
    storeRole.$reset()
    storeRole.getRole(route.params.id)
})


// · 
function toggleEditor() {

    if (editor.value == 'standard') {
        return editor.value = 'custom'
    }

    editor.value = 'standard'
}

</script>
<template>
    <lesli-application-container>
        <lesli-header :title="storeRole.role.name + ' role'">
            <lesli-link button solid warning icon="edit" :to="url.security('roles/:id/edit', route.params.id)">
                Edit role
            </lesli-link>
            <lesli-link button icon="list" :to="url.security('roles')">
                All roles
            </lesli-link>
        </lesli-header>
        <componentFormRole :editable="false"></componentFormRole>
    </lesli-application-container>
</template>
