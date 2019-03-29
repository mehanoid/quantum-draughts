import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import App from './App.vue'
import initStore from './store'
import initCable from './cable'
import initI18n from './i18n'
import router from './router'

Vue.use(Vuetify)

document.addEventListener('DOMContentLoaded', () => {
  const store = initStore()
  const cable = initCable({store})
  const i18n = initI18n()

  new Vue({
    el: '#application',
    render: h => h(App),
    store,
    router,
    cable,
    i18n,
  })
})
