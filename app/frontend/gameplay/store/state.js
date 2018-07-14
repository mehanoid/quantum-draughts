import convertBoards from '../utils/convert_boards'

export default () => {
  return {
    matchId: gon.match.id,
    currentPlayer: gon.match.current_player,
    boards: convertBoards(gon.match.boards),
		selectedCellName: null,
    selectedDraughtId: null,
    possibleMoves: [],
    selectedMoves: []
  }
}
