<template>
  <v-app style="background: transparent;">
    <speedometer v-if="$store.state.car" />
    <circles v-if="$store.state.hud" />
    <optionsMenu v-if="$store.state.menu" />
  </v-app>
</template>

<script>
import store from "@/store/index"
import speedometer from '@/components/speedometer'
import circles from '@/components/circles'
import optionsMenu from '@/components/menu'
export default {
  name: 'App',
  components: {
    speedometer,
    circles,
    optionsMenu
  },
  data () {
    return {

    }
  },
  mounted() {
    this.escapeListener = window.addEventListener("keyup", (event) => {
      if (event.keyCode === 27) { 

      }
    });
    this.messageListener = window.addEventListener("message", (event) => {
      const item = event.data || event.detail; //'detail' is for debugging via browsers
      if (store._actions[item.type]) {
        store.dispatch(item.type, item);
      }
    });
  },
}
</script>

<style>

:root {
  color-scheme: light !important;
}

html {
  overflow: hidden !important;
}

/* width */
::-webkit-scrollbar {
  width: 0px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1;
}

/* Handle */
::-webkit-scrollbar-thumb {
  background: #888;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #555;
}

</style>

