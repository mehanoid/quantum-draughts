<template lang="pug">
  table.board
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}
    tr.row(v-for="row in board")
      th {{ row[0].row }}
      GameBoardCell(
        v-for="cell in row"
        :cell="cell"
        :key="cell.name"
      )
      th {{ row[0].row }}
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}
</template>

<script>
  import GameBoardCell from "./GameBoardCell"

  export default {
    data: function () {
      return {}
    },
    props: {
      board: Array
    },
    components: {
      GameBoardCell
    }
  }
</script>

<style lang="postcss" scoped>
  .board {
    border-collapse: collapse;
  }
</style>
