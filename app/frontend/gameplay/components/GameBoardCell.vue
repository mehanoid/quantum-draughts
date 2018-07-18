<template lang="pug">
  td.cell(
    :class="classNames",
    @click="selectMove(cell)"
  )
    GameBoardDraught(
      v-if="cell.draught",
      :cell="cell",
    )
</template>

<script>
  import {mapGetters, mapActions} from "vuex"
  import GameBoardDraught from "./GameBoardDraught"

  export default {
    data: function () {
      return {}
    },
    props: {
      cell: Object
    },
    computed: {
      ...mapGetters(['currentPossibleMoves', 'selectedMovesCells']),
      classNames() {
        return {
          playable: this.cell.playable,
          'possible-move': this.currentPossibleMoves.includes(this.cell.name),
          'selected-move': this.selectedMovesCells.includes(this.cell)
        }
      }
    },
    methods: {
      ...mapActions(['selectMove', 'move'])
    },
    components: {
      GameBoardDraught
    }
  }
</script>

<style lang="postcss" scoped>
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
      cursor: pointer;

      &:hover {
        background: #fdff8e;
      }
    }

    &.selected-move {
      background: yellow;
    }
  }
</style>
