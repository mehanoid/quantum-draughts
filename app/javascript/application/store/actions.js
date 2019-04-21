import serverApi from '@application/serverApi'

export default {
  async updateCurrentUser({commit}) {
    const {data: currentUser} = await serverApi.currentUserGet()
    commit('setCurrentUser', currentUser)
  },

  async withPageLoader({commit}, callback) {
    try {
      commit('setPageLoading', true)
      await callback()
    }
    finally {
      commit('setPageLoading', false)
    }
  }
}
