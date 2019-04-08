import cellUtils from '@application/utils/cell'
import boardUtils from '@application/utils/board'
import buildMultiboard from '@application/utils/buildMultiboard'
import convertBoards from '@application/utils/convert_boards'

// returns a string equal for moves that differ only in the length of the last step
const moveBaseSignature = (move) => {
  const lastStep = _.takeRight(move, 2)
  const direction = cellUtils.diff(...lastStep).map(n => n > 0 ? '+' : '-').join('')
  return [_.dropRight(move), direction].join('')
}

export default {
  boards(state, getters) {
    const source = getters['history/selectedMatchTurn'] || state.match
    // const source = state.match
    return convertBoards(source.boards)
  },

  multiBoard(state, getters) {
    return buildMultiboard(getters.boards)
  },

  boardsWithSelectedDraught(state, getters) {
    if (!state.selectedCellName) {
      return []
    }
    return getters.boards.filter(board => {
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

  anyCanMove(state) {
    return !state.history.selectedMatchTurnId
  },

  anyCanBeat(state) {
    const move = state.match.possible_moves[0]
    return move && move.beat
  },

  canBeat: (state, getters) => cell => {
    return getters.anyCanMove && state.match.possible_moves.some(move => move.beat && move.cells[0] === cell)
  },

  entanglementInfo(state, getters) {
    if (!state.selectedCellName) {
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
            probability,
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
    // if (!getters.anyCanMove || (state.selectedMoves.length && (getters.anyCanBeat || getters.selectedCell.draught.king))) {
    if (!getters.anyCanMove || (state.selectedMoves.length && getters.anyCanBeat)) {
      // beating is currency possible only in one direction. This is due
      // to problem with endless beating loop when both players can beat
      // with very little probability
      return []
    }
    return state.match.possible_moves.filter(pm =>
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

  currentPlayerUser(state) {
    return state.match.current_player_color === 'white' ?
      state.match.white_player :
      state.match.black_player
  },
}
