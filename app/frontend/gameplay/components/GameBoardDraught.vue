<template lang="pug">
  .draught(
    v-if="draught",
    :class="classNames",
    @click.stop="selectDraught(cell)"
  )
    PieChart(
      :percent="draught.probability"
      :stroke-width="10"
      :color="chartColor"
      :label="label"
    )
    .king-label(v-if="draught.king") ♔
</template>

<script>
  import {mapActions} from "vuex"
  import PieChart from './PieChart'

  export default {
    data: function () {
      return {}
    },
    props: {
      cell: Object
    },
    computed: {
      classNames() {
        return [this.draught.color,
          {
            selectable: this.selectable,
            highlighted: this.isSelectedDraught,
            selected: this.isSelectedCell,
          }
        ]
      },
      draught() {
        return this.cell.draught
      },
      selectable() {
        return this.$store.state.currentPlayer === this.draught.color
      },
      isSelectedCell() {
        return this.$store.state.selectedCellName === this.cell.name
      },
      isSelectedDraught() {
        return this.$store.state.selectedDraughtId === this.draught.id
      },
      chartColor(){
        return this.draught.color === 'white' ? '#ffe090' : '#713002'
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

    &.selectable {
      cursor: pointer;
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
  }
</style>
