<template lang="pug">
  table.board
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}
    tr.row(v-for="row in board")
      th {{ row[0].row }}
      td.cell(v-for="cell in row")
        .draught(v-if="cell.draught", :class="cell.draught.color")
      th {{ row[0].row }}
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}

</template>

<script>
  export default {
    data: function () {
      return {}
    },
    props: {
      board: Array
    }
  }
</script>

<style src="./style.pcss" scoped></style>
