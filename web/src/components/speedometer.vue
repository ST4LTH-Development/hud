<template>
    <div class="speedometer" :style="{ 
        'left': $store.state.minimap.rightX*100 + 3 + '%',
        'top': $store.state.minimap.Y*100 - 3 + '%'
    }">
        <div class="d-flex">
            <div>
                <div class="bg d-flex space-between">
                    <div class="px-1">
                        <span v-if="$store.state.data.car.speed < 100"  class="font-weight-black text-h3 text-grey">0</span>
                        <span v-if="$store.state.data.car.speed < 10"  class="font-weight-black text-h3 text-grey">0</span>
                        <span class="font-weight-black text-h3">{{$store.state.data.car.speed}}</span>
                    </div>
                    <div class="gearbox pr-1">
                        <div class="gear text-caption">
                            {{ $store.state.data.car.gear }}
                            <v-icon size="20" class="text">
                                mdi-cog
                            </v-icon>
                        </div>
                        <span class="text-caption">
                        KM/H    
                        </span>
                    </div>
                </div>
<!--                 <v-progress-linear 
                    bg-color="#31313191" 
                    bg-opacity="100" 
                    :model-value="$store.state.data.car.rpm * 100" 
                    :color="$store.state.data.car.rpm * 100 > 85 ? 'red' : ( $store.state.data.car.rpm * 100 > 75 ? 'orange' : 'white' )"
                    :height="10"
                >
    
                </v-progress-linear> -->
                <div class="speedo">
                    <div class="speedobar" 
                        v-for="index in 24" 
                        :class="
                            $store.state.data.car.rpm*25 > index ? ( index > 13 ? ( index > 20 ? 'bg-red' : 'bg-orange'  ) : 'bg-white' ) : ''
                        "
                    >
                        
                    </div>
                </div>
            </div>
            <div class="d-flex">
                <div class="fuel-bar ml-1">
                    <v-icon size="18">mdi-gas-station</v-icon>
                    <div class="fuel" :style="{ 'height': $store.state.data.car.fuel + '%' }">
                        
                    </div>
                </div>
<!--                 <div class="fuel-bar ml-1" v-if="$store.state.data.car.nitro > 0">
                    <v-icon size="18">mdi-gas-cylinder</v-icon>
                    <div class="fuel bg-blue" :style="{ 'height': $store.state.data.car.nitro + '%' }">
                        
                    </div>
                </div> -->
            </div>
        </div>
        <v-progress-linear class="mt-1" 
            bg-color="#31313191" 
            bg-opacity="100" 
            :model-value="$store.state.data.car.health / 20 - 25" 
            :color="$store.state.data.car.health / 20 - 25 < 5 ? 'red' : ( $store.state.data.car.health / 20 - 25 < 10 ? 'orange' : 'white' )"
            max="25" 
            :height="4"
        >
    
        </v-progress-linear>
        <v-progress-linear class="mt-1" 
            v-if="$store.state.data.car.nitro > 1"
            bg-color="#31313191" 
            bg-opacity="100" 
            :model-value="$store.state.data.car.nitro" 
            color="blue"
            :height="10"
        >
        </v-progress-linear>
    </div>
</template>

<script>
    export default {
        name: 'speedometer',
        data () {
            return {

            }
        },
    }
</script>

<style>

.speedometer { 
  width: fit-content;
  height: fit-content;
  position: absolute;
}

.gearbox { 
  display: flex;
  align-items: center;
  align-content: center;
  flex-direction: column;
  justify-content: center;
}

.fuel-bar {
  position: relative;
  width: 18px;
  height: 100%;
  background-color: #31313191;
}

.fuel {
    width: 18px;
    height: 100%;
    background-color: #ffffff;
    bottom: 0;
    position: absolute;
}

.gear {
  display: flow;
}

.bg {
    background: #31313191;
}

.v-progress-linear__determinate {
    transition: all 0.5s ease!important;
}

.speedo {
    display: flex;
    gap: 2px;
    width: 100%;
    height: 15px;
    transition: all 0.5s;
}

.speedobar {
    width: 4px;
    height: 100%;
    background: #31313191;
    transition: all 0.2s;
}

</style> 