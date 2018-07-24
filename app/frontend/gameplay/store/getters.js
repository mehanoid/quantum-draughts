import cellUtils from '../utils/cell'
import boardUtils from '../utils/board'
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

	boardsWithSelectedDraught(state) {
		if (!state.selectedCellName) {
			return []
		}
		return state.boards.filter(board => {
			return boardUtils.cellByName(board, state.selectedCellName).draught
		})
	},

	multiCells(state, getters) {
		return _.flattenDeep(getters.multiBoard)
	},

	occupiedCells(state, getters) {
		return getters.multiCells.filter(c => c.draught)
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

	entanglementInfo(state, getters) {
		if (!state.selectedDraughtId) {
			return []
		}
		const totalWeight = _.sumBy(getters.boardsWithSelectedDraught, board => board.weight)
		const info = getters.occupiedCells.filter(c => c.draught.id !== state.selectedDraughtId && c.draught.probability < 100)
			.map((multiCell) => {
				const draughtWeight = _(getters.boardsWithSelectedDraught).map(board => {
					const cell = boardUtils.cellByName(board, multiCell.name)
					return cell.draught ? board.weight : 0
				}).sum()

				const probability = Math.round(100 * draughtWeight / totalWeight)

				if (multiCell.draught.probability !== probability) {
					return {
						cellName: multiCell.name,
						probability
					}
				}
			})
		return _.compact(info)
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
