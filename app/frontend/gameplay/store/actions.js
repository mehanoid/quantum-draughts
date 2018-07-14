import serverApi from '../server_api'
import cellUtils from '../utils/cell'

export default {
  async selectDraught({commit, state}, cell) {
    const draught = cell.draught
    if (draught.color === state.currentPlayer) {
			commit('cleanSelections')
			commit('setSelectedDraught', cell)
      const {data: response} = await serverApi.matchPossibleMoves(state.matchId, cell)
      commit('setPossibleMoves', response.cells)
    }
  },

  selectMove({commit, getters, state, dispatch}, cell) {
    if (getters.possibleMovesCells.includes(cell)) {
      const cellName = cellUtils.name(cell)
      commit('addSelectedMove', cellName)

      if (state.selectedMoves.length >= 2 || state.selectedMoves.length >= state.possibleMoves.length) {
        dispatch('move', getters.selectedMovesCells[0])
      }
    }
  },

  async move({commit, getters, state}, to) {
    if (!getters.selectedCell || !getters.possibleMovesCells.includes(to)) {
      return
    }
    const from = getters.selectedCell
    const moves = getters.selectedMovesCells.map(to => [cellUtils.name(from), cellUtils.name(to)])
    commit('move', {from, to})
    commit('setPossibleMoves', [])
    commit('cleanSelections')
    const {data: response} = await serverApi.matchMove(state.matchId, moves)
    commit('updateBoards', response.match.boards)
    commit('setCurrentPlayer', response.match.current_player)
  }
}
