import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

import InitBoards from './initboards'

export default function initStore() {
  return new Vuex.Store({
    state: {
      boards: (new InitBoards(gon.match.boards).getBoards())
    },
    mutations: {}
  })
}
