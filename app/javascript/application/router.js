import Vue from 'vue'
import VueRouter from 'vue-router'
import MatchesShow from './pages/MatchesShow'
import MatchesIndex from './pages/MatchesIndex'
import AboutGame from './pages/AboutGame'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: MatchesIndex,
    },
    {
      path: '/game/matches/:matchId',
      component: MatchesShow,
      props: (route) => ({matchId: +route.params.matchId}),
      name: 'match'
    },
    {
      path: '/about',
      component: AboutGame,
      name: 'about'
    },
  ],
})

