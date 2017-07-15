<template lang="pug">
  table.board
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}
    tr.row(v-for="row in board")
      th {{ row[0].row }}
      td.cell(
        v-for="cell in row",
        :class="{playable: cell.playable}",
        @click="move(cell)"
      )
        Draught(
          v-if="cell.draught",
          :draught="cell.draught",
        )
      th {{ row[0].row }}
    tr
      th
      th(v-for="cell in board[0]") {{ cell.column }}

</template>

<script>
  import {mapActions} from "vuex"
  import Draught from "./draught/"

  export default {
    data: function () {
      return {}
    },
    props: {
      board: Array
    },
    methods: {
      ...mapActions(['move'])
    },
    components: {
      Draught
    }
  }
</script>

<style src="./style.pcss" scoped></style>
