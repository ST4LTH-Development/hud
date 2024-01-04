<template>
    <div class="circles-container">
        <v-progress-circular 
            v-for="item in $store.state.statusBars" 
            :color="$store.state.settings[item.status].color"
            width="6" 
            size="45" 
            :model-value="item.type == 'mic' ? 100 :$store.state.data.status[item.status]"
            v-show="show(item)"
        >
            <v-icon class="text-white" size="small">{{ item.type == 'mic' ? ( $store.state.data.status[item.status] ? 'mdi-microphone' : 'mdi-microphone-off' ) : item.icon }}</v-icon>
        </v-progress-circular>
    </div>
</template>

<script>
    import store from '@/store/index'
    export default {
        name: 'circles',
        data () {
            return {

            }
        },
        methods: {
            show(item){
                if (item.type) {
                    if (item.type == 'reversed') {
                        return store.state.settings[item.status].hide >= store.state.data.status[item.status]
                    } else if (item.type == 'mic') {
                        return true
                    }
                } else {
                    return store.state.settings[item.status].hide <= store.state.data.status[item.status]
                }
            }
        }
    }
</script>

<style>

.circles-container {
    padding: 5px;
    position: absolute;
    bottom: 0;
    display: flex;
    gap: 3px;
}

.v-progress-circular {
    background-color: rgb(39, 39, 39)!important;
    border-radius: 100px;
}

</style>