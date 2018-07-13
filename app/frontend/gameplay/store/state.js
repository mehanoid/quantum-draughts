import convertBoards from './convert_boards'

export default () => {
  return {
    matchId: gon.match.id,
    currentPlayer: gon.match.current_player,
    boards: convertBoards(gon.match.boards),
    selectedDraughtId: null,
    possibleMoves: [],
    selectedMoves: []
  }
}
