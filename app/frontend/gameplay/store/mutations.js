import convertBoards from '../utils/convert_boards'

export default {
  setSelectedDraught(state, cell) {
		state.selectedCellName = cell.name
    state.selectedDraughtId = cell.draught.id
  },

  move(state, {from, to}) {
    to.draught = from.draught
    from.draught = null
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

	cleanSelections(state) {
		state.selectedMoves = []
		state.selectedCellName = null
		state.selectedDraughtId = null
	},

  addSelectedMove(state, cell) {
    state.selectedMoves.push(cell)
  },

  setSelectedMoves(state, moves) {
  	state.selectedMoves = moves
	}
}
