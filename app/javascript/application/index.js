import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import App from './App.vue'
import initStore from './store'
import initCable from './cable'
import i18n from './i18n'
import router from './router'
import serverApi from './serverApi'

Vue.use(Vuetify, {
  theme: {
    primary: '#b3e5fc',
  }
})

document.addEventListener('DOMContentLoaded', () => {
  const store = initStore()
  serverApi.init({store})
  const cable = initCable({store})

  new Vue({
    el: '#application',
    render: h => h(App),
    store,
    router,
    cable,
    i18n,
  })
})
