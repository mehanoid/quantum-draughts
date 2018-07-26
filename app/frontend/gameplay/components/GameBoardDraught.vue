<template lang="pug">
  .draught(
    v-if="draught"
    :class="classNames"
    @click.stop="selectDraught(cell)"
  )
    PieChart(
      :percent="draught.probability"
      :stroke-width="10"
      :color="chartColor"
    )
    PieChart.entanglement(
      v-if="entanglementProbability !== undefined"
      :percent="entanglementProbability"
      :stroke-width="1"
      color="#6f00ac"
      background="#e9d2ff"
    )
    .king-label(v-if="draught.king") ♔
</template>

<script>
  import {mapGetters, mapActions} from "vuex"
  import PieChart from './PieChart'

  export default {
    data: function () {
      return {}
    },
    props: {
      cell: Object
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
    },
    methods: {
      ...mapActions(['selectDraught']),
    },
    components: {PieChart}
  }
</script>

<style lang="postcss" scoped>
  .draught {
    display: inline-block;
    position: relative;
    size: 40px;
    border-radius: 20px;
    vertical-align: middle;
    cursor: pointer;

    &.can-beat {
      box-shadow: 0 0 15px 10px rgb(255, 48, 48);
    }

    &.white {
      background: #ffe090;

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
      background: #713002;

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

    & .king-label {
      position: absolute 0;
      size: 100%;
      font-size: 25px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    & .entanglement {
      position: absolute 0;
    }
  }
</style>
