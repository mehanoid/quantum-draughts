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
      color="#6f00ac"
      backgroundColor="#e9d2ff"
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
      required: true
    },
    entanglementProbability: {
      type: Number,
      default: undefined
    }
  },
  computed: {
    classNames() {
      return [`${this.draught.color}-player`,
        {
          highlighted: this.isSelectedDraught
        }
      ]
    },
    chartColor() {
      return this.draught.color === 'white' ? '#ffe090' : '#713002'
    },
    isSelectedDraught() {
      return this.draught.id && this.draught.id === this.$store.state.selectedDraughtId
    },
  }
}
</script>

<style lang="postcss" scoped>
  .game-draught {
    display: inline-block;
    position: relative;
    width: 40px;
    height: 40px;
    border-radius: 20px;
    vertical-align: middle;
    cursor: pointer;

    &.can-beat {
      box-shadow: 0 0 15px 10px rgb(255, 48, 48);
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
        box-shadow: 0 0 15px 10px rgb(252, 255, 199);
      }

      &.selected {
        box-shadow: 0 0 15px 10px rgb(248, 255, 119);
      }

      & .king-label {
        color: #713002;
      }
    }

    &.black-player {
      &.highlighted {
        box-shadow: 0 0 15px 10px #deb58d;
      }

      &.selected {
        box-shadow: 0 0 15px 10px #de9040;
      }

      & .king-label {
        color: #ffe090;
      }
    }

    & .entanglement {
      position: absolute;
      top: 0;
      left: 0;
    }
  }
</style>
