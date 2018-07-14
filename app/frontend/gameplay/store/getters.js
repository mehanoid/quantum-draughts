import cellUtils from '../utils/cell'
import buildMultiboard from '../utils/build_multiboard'

export default {
  multiBoard(state) {
    return buildMultiboard(state.boards)
  },

  multiCells(state, getters) {
    return _.flattenDeep(getters.multiBoard)
  },

  cellByDraughtId: (state, getters) => id => {
    return getters.multiCells.find(c => c.draught && c.draught.id === id)
  },

	cellByName: (state, getters) => name => {
  	return getters.multiCells.find(c => c.name === name)
	},

  selectedCell(state, getters) {
    return getters.cellByName(state.selectedCellName)
  },

  possibleMovesCells(state, getters) {
    return getters.multiCells.filter((cell) => state.possibleMoves.includes(cellUtils.name(cell)))
  },

  selectedMovesCells(state, getters) {
    return state.selectedMoves.map(move => getters.multiCells.find(cell => move === cellUtils.name(cell) ))
  }
}
