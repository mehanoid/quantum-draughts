// Converting boards from server response format to state format

import {addToChar} from './string'

class InitBoard {
  constructor(boardData) {
    this.boardData = boardData
  }

  getBoard() {
    return {
      rows: this.convertRows(),
      weight: this.boardData.weight
    }
  }

  convertRows() {
    return _.range(8).reverse().map((rowIndex) => {
      const rowNumber = rowIndex + 1
      return _.range(8).map((columnIndex) => {
        const columnChar = addToChar('A', columnIndex)
        return {
          playable: (rowIndex + columnIndex) % 2 === 0,
          column: columnChar,
          row: rowNumber,
          name: `${columnChar}${rowNumber}`,
          draught: this.draughtAt(rowNumber, columnChar)
        }
      })
    })
  }

  draughtAt(row, column) {
    const draught = this.boardData.cells[column + row]
    if (draught){
      return {
        id: draught.id,
        color: InitBoard.expandColor(draught.c),
        weight: this.boardData.weight,
        king: draught.k
      }
    }
  }

  static expandColor(char) {
    switch (char) {
    case 'w':
      return 'white'
    case 'b':
      return 'black'
    }
  }
}

export default function convertBoards(data) {
  return data.map(boardData => new InitBoard(boardData).getBoard())
}
