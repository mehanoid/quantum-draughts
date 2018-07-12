import serverApi from '../server_api'

export default {
  selectDraught({commit, state}, draught) {
    if (draught.color === state.currentPlayer) {
      commit('setSelectedDraughtId', draught.id)
    }
  },

  async move({commit, getters}, to) {
    if (!getters.selectedCell || !to.playable) {
      return
    }
    const from = getters.selectedCell
    commit('move', {from, to})
    const {json: responseJson} = await serverApi.move(gon.match.id, {from, to})
    commit('updateBoards', responseJson.match.boards)
    commit('setCurrentPlayer', responseJson.match.current_player)
  }
}
