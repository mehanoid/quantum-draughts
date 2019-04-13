// Merge all boards into one multiboard

export default function(boards) {
  const flattenBoards = boards.map(board => _.flattenDeep(board.rows))
  const totalWeight = _.sumBy(boards, board => board.weight)
  const multicells = _.zip(...flattenBoards).map(cellsGroup => {
    return reduceMultiCell(cellsGroup, totalWeight)
  })
  return _.chunk(multicells, 8)
}

function reduceMultiCell(cellsGroup, totalWeight) {
  const multicell = cellsGroup.reduce(multiCellReducer)

  if (multicell.draught) {
    // count the number of checker appearances on all boards,
    // based on this, calculate the probabilities
    const draughts = cellsGroup.map(cell => cell.draught).filter(Boolean)
    const weight = _.sumBy(draughts, draught => draught.weight)
    const probability = Math.round(100 * weight / totalWeight)

    return {
      ...multicell,
      draught: {
        ...multicell.draught,
        weight,
        probability,
      },
    }
  }
  else {
    return multicell
  }
}

function multiCellReducer(multicell, cell) {
  return {
    ...multicell,
    draught: multicell.draught || cell.draught,
  }
}
