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
import { useRouter } from "vue-router"


// · import lesli stores
import { useRole } from "LesliGuard/vue/stores/role"
import { useDescriptor } from "LesliGuard/vue/stores/descriptor"


// · initialize/inject plugins
const msg = inject("msg")
const url = inject("url")
const router = useRouter()


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · list, index, show, create, edit, delete
const columnDescriptors = [{
    field: 'name',
    label: 'Name'
},{
    field: 'plist',
    label: 'List',
    align: 'center'
},{
    field: 'pindex',
    label: 'Index',
    align: 'center'
},{
    field: 'pshow',
    label: 'Show',
    align: 'center'
},{
    field: 'pcreate',
    label: 'Create',
    align: 'center'
},{
    field: 'pupdate',
    label: 'Update',
    align: 'center'
},{
    field: 'pdestroy',
    label: 'Delete',
    align: 'center'
}]


// · 
function updatePrivilege(descriptor) {
    storeRole.updatePrivilege(descriptor)
}


// · 
onMounted(() => {
    storeRole.getPrivileges()
})
</script>
<template>
    <lesli-table 
        :columns="columnDescriptors"
        :records="storeRole.privileges">
        <template #head(plist)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        format_list_numbered
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(pindex)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        format_list_bulleted
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(pshow)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        visibility
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(pcreate)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        add
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(pupdate)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        edit
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(pdestroy)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        delete
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>

        <template #name="{ record }">
            <router-link :to="url.guard('descriptors/:id', record.id).toString()">
                {{ record.name }}
            </router-link>
        </template>

        <template #plist="{ record }">
            <lesli-toggle v-if="record.has_list" v-model="record.plist" @change="updatePrivilege(record)">
            </lesli-toggle>&nbsp;
        </template>
        <template #pindex="{ record }">
            <lesli-toggle v-if="record.has_index" v-model="record.pindex" @change="updatePrivilege(record)">
            </lesli-toggle>&nbsp;
        </template>
        <template #pshow="{ record }">
            <lesli-toggle v-if="record.has_show" v-model="record.pshow" @change="updatePrivilege(record)">
            </lesli-toggle>&nbsp;
        </template>
        <template #pcreate="{ record }">
            <lesli-toggle v-if="record.has_create" v-model="record.pcreate" @change="updatePrivilege(record)">
            </lesli-toggle>&nbsp;
        </template>
        <template #pupdate="{ record }">
            <lesli-toggle v-if="record.has_update" v-model="record.pupdate" @change="updatePrivilege(record)">
            </lesli-toggle>&nbsp;
        </template>
        <template #pdestroy="{ record }">
            <lesli-toggle v-if="record.has_destroy" v-model="record.pdestroy" @change="updatePrivilege(record)">
            </lesli-toggle>&nbsp;
        </template>
    </lesli-table>
</template>
