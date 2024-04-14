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


// · import lesli stores
import { useRole } from "LesliSecurity/vue/stores/role"


// · implement stores
const storeRole = useRole()


// · 
const translations = {
    shared: I18n.t("core.shared"),
    passwords: I18n.t("core.users/passwords"),
    users: I18n.t("core.users")
}


// · 
function updateRole(descriptor) {

    if (descriptor.active) {
        return storeRole.postDescriptor(descriptor)
    } 

    return storeRole.deleteDescriptor(descriptor)    
}

</script>
<template>
    <lesli-empty v-if="storeRole.descriptors.length == 0"></lesli-empty>
    <div class="media px-6" v-for="descriptor in storeRole.descriptors">
        <div class="media-content pt-4">
            <h4>{{ descriptor.name }}</h4>
            <p style="color:#aaa;">
                {{ descriptor.description }}
            </p>
        </div>
        <div class="media-right pt-4">
            <lesli-toggle v-model="descriptor.active" @change="updateRole(descriptor)">
            </lesli-toggle>
        </div>
    </div>    
</template>
