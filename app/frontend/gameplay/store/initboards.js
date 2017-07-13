import {addToChar} from '../utils'

export default class InitBoards {
  constructor(data) {
    this.data = data
  }

  getBoards() {
    return this.data.map((boardData) => {
      return _.range(8).map((rowIndex) => {
        const rowNumber = rowIndex + 1
        return _.range(8).map((columnIndex) => {
          const columnChar = addToChar('A', columnIndex)
          return {
            column: columnChar,
            number: rowNumber,
            object: boardData[columnChar + rowNumber]
          }
        })
      })
    })
  }
}
