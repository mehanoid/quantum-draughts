<template lang="pug">
  .board
    v-progress-linear.progress(
      v-if="$store.state.gameplay.progress"
      :indeterminate="true"
    )
    table.board-table
      tr.column-names
        th
        th(v-for="cell in displayingBoard[0]") {{ cell.column }}
      tr.row(v-for="row in displayingBoard")
        th.row-name {{ row[0].row }}
        GameBoardCell(
          v-for="cell in row"
          :cell="cell"
          :key="cell.name"
        )
        th.row-name {{ row[0].row }}
      tr.column-names
        th
        th(v-for="cell in displayingBoard[0]") {{ cell.column }}
</template>

<script>
import GameBoardCell from './GameBoardCell'
import {mapState} from 'vuex'

export default {
  components: {
    GameBoardCell,
  },
  props: {
    board: {
      type: Array,
      required: true,
    },
  },
  data: function () {
    return {}
  },
  computed: {
    ...mapState('gameplay', ['match']),
    ...mapState(['currentUser']),
    displayingBoard() {
      if (this.currentUser && this.match.black_player && this.currentUser.id === this.match.black_player.id) {
        return this.board.map(row => [...row].reverse()).reverse()
      }
      else {
        return this.board
      }
    },
  },
}
</script>

<style lang="postcss" scoped>
.board {
  position: relative;
}

.progress {
  position: absolute;
  margin: calc(25px - 7px) var(--board-padding) 0;
  width: calc(100% - 2 * var(--board-padding));
}

.board-table {
  border-collapse: collapse;
}

.column-names {
  height: var(--board-padding);
}

.row-name {
  width: var(--board-padding);
}

</style>
