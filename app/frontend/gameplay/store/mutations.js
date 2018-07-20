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

	updateMatch(state, match){
  	state.boards = convertBoards(match.boards)
		state.currentPlayer = match.current_player
		state.allPossibleMoves = match.possible_moves
	},

	cleanSelections(state) {
		state.selectedMoves = []
		state.selectedCellName = null
		state.currentMove = []
		state.selectedDraughtId = null
	},

  addSelectedMove(state, cell) {
    state.selectedMoves.push(cell)
  },

	removeSelectedMove(state, cell) {
  	state.selectedMoves = state.selectedMoves.filter(move => move !== cell)
	},

  setSelectedMoves(state, moves) {
  	state.selectedMoves = moves
	},

	addToCurrentMove(state, cell) {
		state.currentMove.push(cell)
	},

	selectCurrentMove(state) {
		state.selectedMoves.push(state.currentMove)
		state.currentMove = []
	}
}
