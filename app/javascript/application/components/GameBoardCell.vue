<template lang="pug">
  td.cell(
    :class="classNames"
    @click="selectCell(cell)"
  )
    GameBoardDraught.draught(
      v-if="cell.draught"
      :cell="cell"
    )
</template>

<script>
import {mapState, mapGetters, mapActions} from 'vuex'
import GameBoardDraught from './GameBoardDraught'

export default {
  components: {
    GameBoardDraught,
  },
  props: {
    cell: {
      type: Object,
      required: true,
    },
  },
  data: function () {
    return {}
  },
  computed: {
    ...mapState('gameplay', ['currentMove']),
    ...mapGetters('gameplay', ['currentPossibleMovesCellNames', 'currentPossibleSteps', 'selectedMovesCellNames']),
    classNames() {
      return {
        playable: this.cell.playable,
        'possible-moves': this.currentPossibleMovesCellNames.includes(this.cell.name),
        'possible-move-step': this.currentPossibleSteps.includes(this.cell.name),
        'current-move': this.currentMove.includes(this.cell.name),
        'selected-move': this.selectedMovesCellNames.includes(this.cell.name),
      }
    },
  },
  methods: {
    ...mapActions('gameplay', ['selectCell']),
  },
}
</script>

<style scoped>
@import "../../stylesheets/media.css";

.cell {
  --size: 45px;

  background: var(--clr-cell-non-playable);
  width: var(--size);
  height: var(--size);
  text-align: center;
  padding: 0;
  transition: background-color 0.2s ease;

  @media (--lg) {
    --size: 55px;
  }

  &.playable {
    background: var(--clr-cell-playable);
  }

  &.possible-moves {
    background: var(--clr-cell-possible-move);
  }

  &.selected-move {
    background: var(--clr-cell-selected);
  }

  &.possible-move-step {
    background: var(--clr-cell-possible-move-step);
    cursor: pointer;

    &:hover {
      background: var(--clr-cell-possible-move-step-hover);
    }
  }

  &.current-move {
    background: var(--clr-cell-current-move);
  }
}

.draught {
  vertical-align: middle;
  display: inline-block;
}
</style>
