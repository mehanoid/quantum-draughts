<template lang="pug">
  table.board
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}
    tr.row(v-for="row in board")
      th {{ row[0].row }}
      td.cell(
        v-for="cell in row",
        :class="{playable: cell.playable, 'possible-move': possibleMovesCells.includes(cell)}",
        @click="move(cell)"
      )
        Draught(
          v-if="cell.draught",
          :cell="cell",
        )
      th {{ row[0].row }}
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}

</template>

<script>
  import {mapGetters, mapActions} from "vuex"
  import Draught from "./draught"

  export default {
    data: function () {
      return {}
    },
    props: {
      board: Array
    },
    computed: {
      ...mapGetters(['possibleMovesCells']),
    },
    methods: {
      ...mapActions(['move'])
    },
    components: {
      Draught
    }
  }
</script>

<style lang="postcss" scoped>
  .board {
    border-collapse: collapse;
  }

  .cell {
    border: 1px solid black;
    size: 55px;
    text-align: center;
    padding: 0;

    &.playable {
      background: #75806f;
    }

    &.possible-move {
      background: green;
    }
  }
</style>
