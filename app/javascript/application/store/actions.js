import serverApi from '@application/serverApi'

export default {
  async updateCurrentPlayer({commit}) {
    const {data: currentPlayer} = await serverApi.currentPlayerGet()
    commit('setCurrentPlayer', currentPlayer)
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
