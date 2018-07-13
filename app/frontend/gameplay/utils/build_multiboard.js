// Merge all boards into one multiboard

export default function(boards) {
  const flattenBoards = boards.map(board => _.flattenDeep(board))
  const multicells = _.zip(...flattenBoards).map(cellsGroup => {
    return reduceMultiCell(cellsGroup, boards.length)
  })
  return _.chunk(multicells, 8)
}

function reduceMultiCell(cellsGroup, boardsCount) {
  const multicell = cellsGroup.reduce(multiCellReducer)

  if (multicell.draught) {
    // count the number of checker appearances on all boards,
    // based on this, calculate the probabilities
    const draughtCount = cellsGroup.filter(cell => cell.draught).length
    const probability = Math.round(100 * draughtCount / boardsCount)

    return {
      ...multicell,
      draught: {
        ...multicell.draught,
        count: draughtCount,
        probability
      }
    }
  }
  else {
    return multicell
  }
}

function multiCellReducer(multicell, cell) {
  return {
    ...multicell,
    draught: multicell.draught || cell.draught
  }
}
