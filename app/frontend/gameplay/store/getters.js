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

	currentMoveStepCellName(state) {
  	return _.last(state.currentMove) || state.selectedCellName
	},

	currentPossibleMoves(state) {
		return state.allPossibleMoves.filter(pm =>
			pm.cells[0] === state.selectedCellName &&
			!state.selectedMoves.some(sm => _.isEqual(sm, _.drop(pm.cells)))
		)
	},

	currentPossibleMovesCellNames(state, getters) {
		return _(getters.currentPossibleMoves)
				.map(pm => _.drop(pm.cells)).flatten().uniq().value()
	},

	currentPossibleSteps(state, getters) {
		const stepIndex = state.currentMove.length
		return _.compact(
			getters.currentPossibleMoves
				.filter(pm => pm.cells[stepIndex] === getters.currentMoveStepCellName)
				.map(pm => pm.cells[stepIndex + 1])
		)
	},

	selectedMovesCells(state, getters) {
  	const cellsNames = _.flatten(state.selectedMoves)
		return cellsNames.map(move_cell =>
			getters.multiCells.find(cell => move_cell === cellUtils.name(cell))
		)
  }
}
