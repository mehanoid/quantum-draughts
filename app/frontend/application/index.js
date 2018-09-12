import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import App from './App.vue'
import initStore from './store'
import initCable from './cable'
import router from './router'

Vue.use(Vuetify)

Object.defineProperty(Vue.prototype, '$cable', {
  get: function () {
    return this.$root.$options.cable
  },
})

document.addEventListener('DOMContentLoaded', () => {
  const store = initStore()
  const cable = initCable({store})

  const page = document.getElementById('gameplay').dataset.page

  new Vue({
    el: '#gameplay',
    render: h => h(App, {attrs: {page}}),
    store,
    router,
    cable,
  })
})
