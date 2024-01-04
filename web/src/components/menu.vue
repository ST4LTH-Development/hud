<template>
    <v-card class="options" >
        <v-card-title class="d-flex px-2 ">
            Settings 
            <div style="flex-grow: 1;">

            </div>
            <v-btn @click="Save" variant="flat" color="grey-darken-3">Save</v-btn>
        </v-card-title>
        <v-divider></v-divider>
        <v-list>
            <v-list-item class="mt-1 bg-bg mx-2 rounded pr-1" v-for="item in $store.state.statusBars">
                <v-icon class="mr-2">{{ item.icon }}</v-icon>
                {{ item.label }}
                <template v-slot:append>
                    <v-text-field 
                        v-model="$store.state.settings[item.status].hide" 
                        type="number" 
                        class="mr-2" 
                        width="600" 
                        hide-details 
                        :label="item.type == 'reversed' ? '100 = never hide' : '0 = never hide'"
                        variant="underlined">
                    </v-text-field>
                    <v-select hide-details v-model="$store.state.settings[item.status].color"
                        label="Color"
                        :items="colors"
                        variant="solo"
                    ></v-select>
                </template>
            </v-list-item>
        </v-list>
    </v-card>
</template>

<script>
    import store from '@/store/index';
    export default {
        name: 'circles',
        data () {
            return {
                statusBars: [
                    { status: 'mic', label: 'Microphone', icon: 'mdi-microphone' },
                    { status: 'health', label: 'Health', icon: 'mdi-heart' },
                    { status: 'armor', label: 'Armor', icon: 'mdi-shield' },
                    { status: 'hunger', label: 'Hunger', icon: 'mdi-food' },
                    { status: 'thirst', label: 'Thirst', icon: 'mdi-water' },
                    { status: 'stress', label: 'Stress', icon: 'mdi-brain' },
                    { status: 'stamina', label: 'Stamina', icon: 'mdi-gas-cylinder' },
                ],
                colors: [
                    'white',
                    'black',
                    'blue',
                    'green',
                    'yellow',
                    'orange',
                    'red',
                    'pink',
                    'purple',
                ]
            }
        },
        methods: {
            Save(){
                store.dispatch('Save')
            }
        }
    }
</script>

<style>

.options {
    position: absolute;
    width: 70vh;
    max-height: 70vh;
    height: fit-content;
    top: 0;
    bottom: 0;
    right: 0;
    left: 0;
    margin: auto;
}

.v-field__input {
    min-width: 12vh!important;
}

.v-field--variant-solo, .v-field--variant-solo-filled {
    box-shadow: 0px 0px 0px 0px black!important;
}

</style>