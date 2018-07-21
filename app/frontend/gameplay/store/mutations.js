import convertBoards from '../utils/convert_boards'

export default {
  setSelectedDraught(state, cell) {
		state.selectedCellName = cell.name
    state.selectedDraughtId = cell.draught.id
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
