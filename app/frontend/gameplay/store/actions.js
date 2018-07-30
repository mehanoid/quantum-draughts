import serverApi from '../serverApi'
import cellUtils from '../utils/cell'

const MAX_MOVES_COUNT = 2

export default {
	selectCell({commit, state, getters, dispatch}, cell) {
		if (!state.selectedCellName) {
			dispatch('selectDraught', cell)
		}
		else {
			if (!getters.currentPossibleSteps.includes(cell.name)) {
				commit('cleanSelections')
			}
			else {
				dispatch('selectMove', cell)
			}
		}
	},

	selectDraught({commit, state}, cell) {
		commit('cleanSelections')
		commit('setSelectedDraught', cell)
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
		if (response.error) {
			alert(response.error)
		}
	}
}
