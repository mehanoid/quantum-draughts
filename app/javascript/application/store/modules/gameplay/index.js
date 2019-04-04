import state from './state'
import getters from './getters'
import mutations from './mutations'
import actions from './actions'
import modules from './modules'

export default {
  namespaced: true,
  state: state,
  getters,
  mutations,
  actions,
  modules: modules,
  strict: process.env.NODE_ENV !== 'production',
}
