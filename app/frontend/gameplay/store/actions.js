import serverApi from '../server_api'

export default {
  async selectDraught({commit, state}, cell) {
    const draught = cell.draught
    if (draught.color === state.currentPlayer) {
      commit('setSelectedDraughtId', draught.id)
      const {data: response} = await serverApi.matchPossibleMoves(state.matchId, cell)
      commit('setPossibleMoves', response.cells)
    }
  },

  async move({commit, getters, state}, to) {
    if (!getters.selectedCell || !to.playable) {
      return
    }
    const from = getters.selectedCell
    commit('move', {from, to})
    commit('setPossibleMoves', [])
    const {data: response} = await serverApi.matchMove(state.matchId, {from, to})
    commit('updateBoards', response.match.boards)
    commit('setCurrentPlayer', response.match.current_player)
  }
}
