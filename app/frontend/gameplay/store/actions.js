import serverApi from '../server_api'
import cellUtils from '../utils/cell'

const MAX_MOVES_COUNT = 2

export default {
	selectDraught({commit, state}, cell) {
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
			if (!state.selectedMoves.length && getters.currentPossibleMoves.length <= MAX_MOVES_COUNT) {
				while (getters.currentPossibleMoves.length) {
					commit('addSelectedMove', getters.currentPossibleMoves[0])
				}
			}
			else {
				const cellName = cellUtils.name(cell)
				commit('addToCurrentMove', cellName)

				if (!getters.currentPossibleSteps.length) {
					commit('selectCurrentMove')
				}
			}

			if (state.selectedMoves.length >= MAX_MOVES_COUNT || !getters.currentPossibleMoves.length) {
				dispatch('move')
			}
		}
	},

	async move({commit, getters, state}) {
		if (!state.selectedMoves.length) {
			return
		}
		const promise = serverApi.matchMove(state.match.id, state.selectedMoves)
		commit('cleanSelections')
		const {data: response} = await promise
		commit('updateMatch', response.match)
		if (response.error) {
			alert(response.error)
		}
	}
}
