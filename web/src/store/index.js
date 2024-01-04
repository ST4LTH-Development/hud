import { createStore } from 'vuex'

const resourceName = (window).GetParentResourceid ? (window).GetParentResourceid() : 'hud';

export default createStore({
  state: {
    car: false,
    menu: false,
    hud: false,
    minimap: {
      rightX: 0,
      Y: 0
    },

    statusBars: [
      { status: 'mic', type: 'mic', label: 'Microphone', icon: 'mdi-microphone' },
      { status: 'health', label: 'Health', icon: 'mdi-heart' },
      { status: 'armor', label: 'Armor', icon: 'mdi-shield' },
      { status: 'hunger', label: 'Hunger', icon: 'mdi-hamburger' },
      { status: 'thirst', label: 'Thirst', icon: 'mdi-cup' },
      { status: 'stress', label: 'Stress', icon: 'mdi-brain' },
      { status: 'stamina', type: 'reversed', label: 'Stamina', icon: 'mdi-gas-cylinder' },
    ],
    data: {
      status: {
        mic: true,
        health: 50,
        armor: 50,
        hunger: 50,
        thirst: 50,
        stress: 50,
        stamina: 50,
      },
      car: {
        speed: 10,
        fuel: 10,
        gear: 1,
        rpm: 1,
      }
    },
    settings: {
      mic: {
        color: 'white',
        hide: 100,
      },
      health: {
        color: 'green',
        hide: 100,
      },
      armor: {
        color: 'blue',
        hide: 1,
      },
      hunger: {
        color: 'orange',
        hide: 0,
      },
      thirst: {
        color: 'blue',
        hide: 0,
      },
      stress: {
        color: 'white',
        hide: 1,
      },
      stamina: {
        color: 'white',
        hide: 99,
      },
    }
  },
  actions: {
/*     play() {
      post("play", this.state.char.citizenid, (res) => {
        if (res.type == 'spawn') {
          this.state.spawn = true
          this.state.spawnList = res.spawns
        } else if (res.type == 'recent') {
          this.state.char = null
        }
      });
    }, */
    toggleCar(_commit, item){
      this.state.car = item.toggle
    },
    Update(_comit, item){
      this.state.data = item.data
    },
    Open(){
      this.state.menu = true
    },
    Save(){
      this.state.menu = false
      post("save", this.state.settings);
    },
    Load(_comit, item){
      this.state.hud = true
      this.state.settings = item.settings
    },
    minimap(_comit, item) {
      this.state.minimap = item.minimap
    },
    hide(_comit, item) {
      this.state.hud = false
    },
    show(_comit, item) {
      this.state.hud = true
    }
  },
})

const post = (event, data, cb) => {
  if (event) {
    if (cb) {
      fetch(`https://${resourceName}/${event}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(data || {}),
      })
        .then((resp) => resp.json())
        .then((resp) => {
          if (cb) {
            cb(resp);
          }
        });
    } else {
      fetch(`https://${resourceName}/${event}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(data || {}),
      })
    }
  }
};

