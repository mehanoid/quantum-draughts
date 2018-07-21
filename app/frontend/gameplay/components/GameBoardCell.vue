<template lang="pug">
  td.cell(
    :class="classNames"
    @click="selectMove(cell)"
  )
    GameBoardDraught(
      v-if="cell.draught"
      :cell="cell"
    )
</template>

<script>
  import {mapState, mapGetters, mapActions} from "vuex"
  import GameBoardDraught from "./GameBoardDraught"

  export default {
    data: function () {
      return {}
    },
    props: {
      cell: Object
    },
    computed: {
      ...mapState(['currentMove']),
      ...mapGetters(['currentPossibleMovesCellNames', 'currentPossibleSteps', 'selectedMovesCellNames']),
      classNames() {
        return {
          playable: this.cell.playable,
          'possible-moves': this.currentPossibleMovesCellNames.includes(this.cell.name),
          'possible-move-step': this.currentPossibleSteps.includes(this.cell.name),
          'current-move': this.currentMove.includes(this.cell.name),
          'selected-move': this.selectedMovesCellNames.includes(this.cell.name),
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

    &.possible-moves {
      background: #56804f;
    }

    &.selected-move {
      background: yellow;
    }

    &.possible-move-step {
      background: green;
      cursor: pointer;

      &:hover {
        background: #fdff8e;
      }
    }

    &.current-move {
      background: #00ffd6;
    }
  }
</style>
