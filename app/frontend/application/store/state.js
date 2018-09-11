export default () => {
  return {
    match: gon.match,
    selectedCellName: null,
    selectedDraughtId: null,
    selectedMoves: [],
    currentMove: [],
    progress: false
  }
}
