<template lang="pug">
  .game-draught(
    :class="classNames"
  )
    PieChart(
      :percent="draught.probability"
      :width="1"
      :color="chartColor"
    )
    PieChart.entanglement(
      v-if="entanglementProbability !== undefined"
      :percent="entanglementProbability"
      :width="0.1"
      color="var(--clr-draught-entanglement)"
      backgroundColor="var(--clr-draught-entanglement-bg)"
    )
    .king-label(v-if="draught.king") ♔
</template>

<script>
import PieChart from './PieChart'

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
  },
  computed: {
    classNames() {
      return [`${this.draught.color}-player`,
        {
          highlighted: this.isSelectedDraught,
        },
      ]
    },
    chartColor() {
      return this.draught.color === 'white' ? 'var(--clr-draught-white)' : 'var(--clr-draught-black)'
    },
    isSelectedDraught() {
      return this.draught.id && this.draught.id === this.$store.state.selectedDraughtId
    },
  },
}
</script>

<style scoped>
  .game-draught {
    display: inline-block;
    position: relative;
    width: 40px;
    height: 40px;
    border-radius: 20px;
    vertical-align: middle;
    cursor: pointer;

    &.can-beat {
      box-shadow: 0 0 15px 10px var(--clr-draught-highlight-beat);
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
    }

    &.white-player {
      &.highlighted {
        box-shadow: 0 0 15px 10px var(--clr-draught-white-highlighted);
      }

      &.selected {
        box-shadow: 0 0 15px 10px var(--clr-draught-white-selected);
      }

      & .king-label {
        color: var(--clr-draught-black);
      }
    }

    &.black-player {
      &.highlighted {
        box-shadow: 0 0 15px 10px var(--clr-draught-black-highlighted);
      }

      &.selected {
        box-shadow: 0 0 15px 10px var(--clr-draught-black-selected);
      }

      & .king-label {
        color: var(--clr-draught-white);
      }
    }

    & .entanglement {
      position: absolute;
      top: 0;
      left: 0;
    }
  }
</style>
