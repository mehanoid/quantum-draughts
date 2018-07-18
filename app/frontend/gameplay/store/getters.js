import cellUtils from '../utils/cell'
import buildMultiboard from '../utils/build_multiboard'

export default {
  multiBoard(state) {
    return buildMultiboard(state.boards)
  },

  multiCells(state, getters) {
    return _.flattenDeep(getters.multiBoard)
  },

	cellByName: (state, getters) => name => {
  	return getters.multiCells.find(c => c.name === name)
	},

  selectedCell(state, getters) {
    return getters.cellByName(state.selectedCellName)
  },

	canBeat: (state) => cell => {
  	return state.allPossibleMoves.some(move => move.beat && move.cells[0] === cell)
	},

	currentPossibleMoves(state) {
		return state.allPossibleMoves.filter(pm => pm.cells[0] === state.selectedCellName).map(pm => pm.cells[1])
	},

  selectedMovesCells(state, getters) {
    return state.selectedMoves.map(move => getters.multiCells.find(cell => move === cellUtils.name(cell) ))
  }
}
