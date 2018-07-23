import Vue from 'vue'
import App from './components/App.vue'
import initStore from './store'

document.addEventListener('turbolinks:load', () => {
	if (!gon.match) {
		return
	}

  const app = new Vue({
    el: '#gameplay',
    store: initStore(),
    render: h => h(App)
  })
})
