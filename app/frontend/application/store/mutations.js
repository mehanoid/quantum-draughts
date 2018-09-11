export default {
  setSelectedCell(state, cell) {
    if (!cell.draught) {
      return
    }
    state.selectedDraughtId = cell.draught.id
    state.selectedCellName = cell.name
  },

  setSelectedDraughtId(state, draughtId) {
    state.selectedDraughtId = draughtId
  },

  updateMatch(state, match){
    state.match = match
  },

  cleanSelections(state) {
    state.selectedMoves = []
    state.selectedCellName = null
    state.currentMove = []
    state.selectedDraughtId = null
  },

  addToCurrentMove(state, cell) {
    state.currentMove.push(cell)
  },

  addSelectedMove(state, move) {
    state.selectedMoves.push(move)
  },

  selectCurrentMove(state) {
    state.selectedMoves.push([state.selectedCellName, ...state.currentMove])
    state.currentMove = []
  },

  setMatchProgress(state, value) {
    state.progress = value
  }
}
