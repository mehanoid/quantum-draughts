<template lang="pug">
  td.cell(
    :class="classNames"
    @click="selectCell(cell)"
  )
    GameBoardDraught(
      v-if="cell.draught"
      :cell="cell"
    )
</template>

<script>
import {mapState, mapGetters, mapActions} from 'vuex'
import GameBoardDraught from './GameBoardDraught'

export default {
  components: {
    GameBoardDraught
  },
  props: {
    cell: {
      type: Object,
      required: true
    }
  },
  data: function () {
    return {}
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
    ...mapActions(['selectCell']),
  }
}
</script>

<style lang="postcss" scoped>
.cell {
  border: 1px solid black;
  width: 55px;
  height: 55px;
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
