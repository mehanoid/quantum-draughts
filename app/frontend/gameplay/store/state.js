import convertBoards from '../utils/convert_boards'

export default () => {
  return {
  	match: gon.match,
		selectedCellName: null,
    selectedDraughtId: null,
    selectedMoves: [],
		currentMove: []
  }
}
