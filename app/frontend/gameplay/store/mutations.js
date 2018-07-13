import convertBoards from './convert_boards'

export default {
  setSelectedDraughtId(state, draughtId) {
    state.selectedDraughtId = draughtId
  },

  move(state, {from, to}) {
    to.draught = from.draught
    from.draught = null
    state.selectedDraughtId = null
  },

  updateBoards(state, boardsData) {
    state.boards = convertBoards(boardsData)
  },

  setCurrentPlayer(state, player) {
    state.currentPlayer = player
  },

  setPossibleMoves(state, cells) {
    state.possibleMoves = cells
  },

  cleanSelectedMoves(state) {
    state.selectedMoves = []
  },

  addSelectedMove(state, cell) {
    state.selectedMoves.push(cell)
  }
}
