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


// · import lesli stores
import { useRole } from "LesliGuard/stores/role"
import { useDescriptor } from "LesliGuard/stores/descriptor"


// · initialize/inject plugins
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · list, index, show, create, edit, delete
const columnDescriptors = [{
    field: 'name',
    label: 'Name'
},{
    field: 'power_list',
    label: 'List',
    align: 'center'
},{
    field: 'power_index',
    label: 'Index',
    align: 'center'
},{
    field: 'power_show',
    label: 'Show',
    align: 'center'
},{
    field: 'power_create',
    label: 'Create',
    align: 'center'
},{
    field: 'power_update',
    label: 'Update',
    align: 'center'
},{
    field: 'power_destroy',
    label: 'Delete',
    align: 'center'
}]


// · 
function updateDescriptor(descriptor) {
    storeRole.updateDescriptor(descriptor)
}

</script>
<template>

    <lesli-table 
        :columns="columnDescriptors"
        :records="storeRole.descriptors">
        <template #head(power_list)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        format_list_numbered
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(power_index)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        format_list_bulleted
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(power_show)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        visibility
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(power_create)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        add
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(power_update)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        edit
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(power_destroy)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        delete
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>

        <template #power_list="{ record, value }">
            <lesli-toggle v-if="record.has_show" v-model="record.power_show" @change="updateDescriptor(record.show)">
            </lesli-toggle>
        </template>
        <template #power_index="{ record, value }">
            <lesli-toggle v-if="record.has_index" v-model="record.power_index" @change="updateDescriptor(record)">
            </lesli-toggle>
        </template>
        <template #power_show="{ record, value }">
            <lesli-toggle v-if="record.has_show" v-model="record.power_show" @change="updateDescriptor(record.show)">
            </lesli-toggle>
        </template>
        <template #power_create="{ record, value }">
            <lesli-toggle v-if="record.has_create" v-model="record.power_create" @change="updateDescriptor(record.create)">
            </lesli-toggle>
        </template>
        <template #power_update="{ record, value }">
            <lesli-toggle v-if="record.has_update" v-model="record.power_update" @change="updateDescriptor(record.update)">
            </lesli-toggle>
        </template>
        <template #power_destroy="{ record, value }">
            <lesli-toggle v-if="record.has_destroy" v-model="record.power_destroy" @change="updateDescriptor(record.destroy)">
            </lesli-toggle>
        </template>
    </lesli-table>
</template>
