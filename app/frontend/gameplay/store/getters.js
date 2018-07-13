import cellUtils from '../utils/cell'

export default {
  currentBoard(state) {
    return state.boards[0]
  },

  currentCells(state, getters) {
    return _.flattenDeep(getters.currentBoard)
  },

  cellById: (state, getters) => id => {
    return getters.currentCells.find(c => c.draught && c.draught.id === id)
  },

  selectedCell(state, getters) {
    return getters.cellById(state.selectedDraughtId)
  },

  possibleMovesCells(state, getters) {
    return getters.currentCells.filter((cell) => state.possibleMoves.includes(cellUtils.name(cell)))
  }
}
