import serverApi from '../server_api'
import cellUtils from '../utils/cell'

export default {
  async selectDraught({commit, state}, cell) {
		if (state.selectedCellName === cell.name) {
			commit('cleanSelections')
		}
		else {
			commit('cleanSelections')
			commit('setSelectedDraught', cell)
		}
  },

	selectMove({commit, getters, state, dispatch}, cell) {
		if (getters.currentPossibleSteps.includes(cell.name)) {
			const cellName = cellUtils.name(cell)
			commit('addToCurrentMove', cellName)

			if (!getters.currentPossibleSteps.length) {
				commit('selectCurrentMove')
			}

			if (state.selectedMoves.length >= 2 || !getters.currentPossibleMoves.length){
				dispatch('move', cell)
			}
		}
	},

  async move({commit, getters, state}, to) {
    if (!getters.selectedCell) {
      return
    }
    const from = getters.selectedCell
    const moves = state.selectedMoves.map(moveCells => [cellUtils.name(from), ...moveCells])
    commit('move', {from, to})
    commit('cleanSelections')
    const {data: response} = await serverApi.matchMove(state.matchId, moves)
    commit('updateMatch', response.match)
  }
}
