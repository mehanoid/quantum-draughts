import convertBoards from './convert_boards'

export default () => {
  return {
    currentPlayer: gon.match.current_player,
    boards: convertBoards(gon.match.boards),
    selectedDraughtId: null
  }
}
