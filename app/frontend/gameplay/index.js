import Vue from 'vue'
import App from './components/app.vue'
import initStore from './store'

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#gameplay',
    store: initStore(),
    render: h => h(App)
  })
})
