import cellUtils from '../utils/cell'
import buildMultiboard from '../utils/build_multiboard'

// returns a string equal for moves that differ only in the length of the last step
const moveBaseSignature = (move) => {
	const lastStep = _.takeRight(move, 2)
	const direction = cellUtils.diff(...lastStep).map(n => n > 0 ? '+' : '-').join('')
	return [_.dropRight(move), direction].join('')
}

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

	selectedMovesBaseSignatures(state) {
  	return state.selectedMoves.map(moveBaseSignature)
	},

	currentPossibleMoves(state, getters) {
		return state.allPossibleMoves.filter(pm =>
			pm.cells[0] === state.selectedCellName &&
			!state.selectedMoves.some(sm => _.isEqual(sm, pm.cells)) &&
			!getters.selectedMovesBaseSignatures.includes(moveBaseSignature(pm.cells))
		).map(pm => pm.cells)
	},

	currentPossibleMovesCellNames(state, getters) {
		return _(getters.currentPossibleMoves)
				.map(pm => _.drop(pm)).flatten().uniq().value()
	},

	currentPossibleSteps(state, getters) {
		const stepIndex = state.currentMove.length
		return _.compact(
			getters.currentPossibleMoves
				.filter(pm => pm[stepIndex] === getters.currentMoveStepCellName)
				.map(pm => pm[stepIndex + 1])
		)
	},

	selectedMovesCellNames(state) {
  	return _.uniq(_.flatten(state.selectedMoves.map(_.drop)))
  },
}
