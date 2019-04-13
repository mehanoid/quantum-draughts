<template lang="pug">
  .root
    .game-draught(
      :class="classNames"
    )
      PieChart.draught-chart(
        :percent="probability"
        :width="1"
        :color="chartColor"
      )
      PieChart.entanglement(
        v-if="entanglementProbability !== undefined"
        :percent="entanglementProbability"
        :width="0.1"
        :color="entanglementColor"
        :backgroundColor="entanglementBg"
        :backgroundOpacity="1"
      )
      .king-label(v-if="draught.king") ♚
</template>

<script>
import PieChart from './PieChart'
import {mapState} from 'vuex'

export default {
  components: {PieChart},
  props: {
    draught: {
      type: Object,
      required: true,
    },
    entanglementProbability: {
      type: Number,
      default: undefined,
    },
    canBeat: {
      type: Boolean,
      default: false,
    },
    selected: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapState('gameplay', ['selectedDraughtId']),
    classNames() {
      return [`${this.draught.color}-player`,
        {
          highlighted: this.isSelectedDraught,
          selected: this.selected,
          'can-beat': this.canBeat,
        },
      ]
    },
    chartColor() {
      return this.draught.color === 'white' ? 'var(--clr-draught-white)' : 'var(--clr-draught-black)'
    },
    entanglementColor() {
      return this.draught.color === 'white' ?
        'var(--clr-draught-white-entanglement)' :
        'var(--clr-draught-black-entanglement)'
    },
    entanglementBg() {
      return this.draught.color === 'white' ?
        'var(--clr-draught-white-entanglement-bg)' :
        'var(--clr-draught-black-entanglement-bg)'
    },
    isSelectedDraught() {
      return this.draught.id && this.draught.id === this.selectedDraughtId
    },
    probability() {
      return this.draught.probability != null ? this.draught.probability : 100
    },
  },
}
</script>

<style scoped>
.root {
  --_draught-size: var(--draught-size, 40px);

  width: var(--_draught-size);
  height: var(--_draught-size);
}

.game-draught {
  width: 100%;
  height: 100%;
  position: relative;
  border-radius: 50%;
  cursor: pointer;
  transition: box-shadow 0.2s ease;

  &.can-beat,
  &.highlighted,
  &.selected {
    box-shadow: 0 0 calc(var(--_draught-size) / 2.5) calc(var(--_draught-size) / 4) var(--clr-draught-shadow);
  }

  &.can-beat {
    --clr-draught-shadow: var(--clr-draught-highlight-beat);
  }

  &.highlighted {
    --clr-draught-shadow: var(--clr-draught-highlighted);
  }

  &.selected {
    --clr-draught-shadow: var(--clr-draught-selected);
  }

  & .king-label {
    position: absolute;
    top: 0;
    width: 100%;
    height: 100%;
    font-size: 25px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--clr-cell-playable);
  }

  &.white-player {
    --clr-draught-highlighted: var(--clr-draught-white-highlighted);
    --clr-draught-selected: var(--clr-draught-white-selected);
    --clr-king-label: var(--clr-draught-black);
  }

  &.black-player {
    --clr-draught-highlighted: var(--clr-draught-black-highlighted);
    --clr-draught-selected: var(--clr-draught-black-selected);
    --clr-king-label: var(--clr-draught-white);
  }
}

.draught-chart {
  display: block;
}

.entanglement {
  position: absolute;
  top: 0;
  left: 0;
  transform: scale(1.05);
}
</style>
