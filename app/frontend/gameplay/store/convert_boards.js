// Converting boards from server response format to state format

import {addToChar} from '../utils'

class InitBoard {
  constructor(boardData) {
    this.boardData = boardData
  }

  getBoard() {
    return _.range(8).reverse().map((rowIndex) => {
      const rowNumber = rowIndex + 1
      return _.range(8).map((columnIndex) => {
        const columnChar = addToChar('A', columnIndex)
        return {
          playable: (rowIndex + columnIndex) % 2 === 0,
          column: columnChar,
          row: rowNumber,
          draught: this.draughtAt(rowNumber, columnChar)
        }
      })
    })
  }

  draughtAt(row, column) {
    const draught = this.boardData[column + row]
    if (draught){
      return {
        id: draught.id,
        color: InitBoard.expandColor(draught.c)
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
  return data.map((boardData) => new InitBoard(boardData).getBoard())
}
