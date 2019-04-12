import serverApi from '@application/serverApi.js'
import cellUtils from '@application/utils/cell'
import i18n from '@application/i18n'

const MAX_MOVES_COUNT = 2

export default {
  selectCell({commit, state, getters, dispatch}, cell) {
    if (!state.selectedCellName) {
      commit('cleanSelections')
      commit('setSelectedCell', cell)
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

  selectDraught({commit, state}, draught) {
    if (state.selectedDraughtId !== draught.id) {
      commit('cleanSelections')
      commit('setSelectedDraughtId', draught.id)
    }
    else {
      commit('cleanSelections')
      commit('setSelectedDraughtId', null)
    }
  },

  selectMove({commit, getters, state, dispatch}, cell) {
    if (getters.currentPossibleSteps.includes(cell.name)) {
      const cellName = cellUtils.name(cell)
      commit('addToCurrentMove', cellName)
      const moveCandidates = getters.currentPossibleMoves.filter(move => move[1] === cellName)

      if (!state.selectedMoves.length && getters.currentPossibleMoves.length <= MAX_MOVES_COUNT
        && moveCandidates.length === 1) {
        commit('addSelectedMove', moveCandidates[0])
        while (getters.currentPossibleMoves.length) {
          commit('addSelectedMove', getters.currentPossibleMoves[0])
        }
      }
      else {
        if (!getters.currentPossibleSteps.length) {
          commit('selectCurrentMove')
        }
      }

      if (state.selectedMoves.length >= MAX_MOVES_COUNT || !getters.currentPossibleMoves.length) {
        dispatch('move')
      }
    }
  },

  async move({commit, state}) {
    if (!state.selectedMoves.length) {
      return
    }
    try {
      commit('setMatchProgress', true)
      const promise = serverApi.matchMove(state.match.id, state.selectedMoves)
      commit('cleanSelections')
      const {data: response} = await promise

      if (response.error) {
        commit('snackbars/push', {text: response.error}, {root: true})
      }
    }
    finally {
      commit('setMatchProgress', false)
    }
  },

  async join({state, dispatch}) {
    await serverApi.matchJoin(state.match.id)
    dispatch('updateCurrentUser', null, {root: true})
  },
}
