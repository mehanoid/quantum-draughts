import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'
import getters from './getters'
import mutations from './mutations'
import actions from './actions'
import modules from './modules/index'

Vue.use(Vuex)

let store

export default function initStore() {
  store = new Vuex.Store({
    state: state,
    getters,
    mutations,
    actions,
    modules: modules,
    strict: process.env.NODE_ENV !== 'production'
  })
  return store
}

if (module.hot) {
  // accept actions and mutations as hot modules
  module.hot.accept(['./getters', './mutations', './actions', './modules'], () => {
    // require the updated modules
    // have to add .default here due to babel 6 module output
    const newGetters = require('./getters').default
    const newMutations = require('./mutations').default
    const newActions = require('./actions').default
    const newModules = require('./modules/index').default
    // swap in the new actions and mutations
    store.hotUpdate({
      getters: newGetters,
      mutations: newMutations,
      actions: newActions,
      modules: newModules,
    })
  })
}
