import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'
import getters from './getters'
import mutations from './mutations'
import actions from './actions'

Vue.use(Vuex)

export default function initStore() {
  return new Vuex.Store({
    state: state(),
    getters,
    mutations,
    actions,
  })
}
