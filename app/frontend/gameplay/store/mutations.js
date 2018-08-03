export default {
  setSelectedCell(state, cell) {
    state.selectedCellName = cell.name
    state.selectedDraughtId = cell.draught.id
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
  }
}
