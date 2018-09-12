import Vue from 'vue'
import VueRouter from 'vue-router'
import MatchesShow from './pages/MatchesShow'
import MatchesIndex from './pages/MatchesIndex'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    {path: '/', component: MatchesIndex},
    {path: '/game/matches/:id', component: MatchesShow},
  ],
})

