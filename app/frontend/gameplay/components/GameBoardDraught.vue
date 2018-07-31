<template lang="pug">
  .draught(
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
import {mapGetters} from 'vuex'
import PieChart from './PieChart'

export default {
  components: {PieChart},
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
    ...mapGetters(['entanglementInfo']),
    classNames() {
      return [this.draught.color,
        {
          highlighted: this.isSelectedDraught,
          selected: this.isSelectedCell,
          'can-beat': this.canBeat,
        }
      ]
    },
    draught() {
      return this.cell.draught
    },
    selectable() {
      return this.$store.state.match.current_player === this.draught.color
    },
    isSelectedCell() {
      return this.$store.state.selectedCellName === this.cell.name
    },
    isSelectedDraught() {
      return this.$store.state.selectedDraughtId === this.draught.id
    },
    chartColor(){
      return this.draught.color === 'white' ? '#ffe090' : '#713002'
    },
    canBeat(){
      return this.$store.getters.canBeat(this.cell.name)
    },
    entanglementProbability() {
      const info = this.entanglementInfo.find(i => i.cellName === this.cell.name)
      return info && info.probability
    }
  }
}
</script>

<style lang="postcss" scoped>
  .draught {
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

    &.white {
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

    &.black {
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
