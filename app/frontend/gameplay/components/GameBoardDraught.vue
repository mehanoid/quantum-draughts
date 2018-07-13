<template lang="pug">
  .draught(
    v-if="draught",
    :class="[draught.color, {selectable: selectable, selected: selected}]",
    @click.stop="selectDraught(cell)"
  )
    PieChart(
      :percent="draught.probability"
      :stroke-width="10"
      :color="chartColor"
    )
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
      draught() {
        return this.cell.draught
      },
      selectable() {
        return this.$store.state.currentPlayer === this.draught.color
      },
      selected() {
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
    size: 40px;
    border-radius: 20px;
    vertical-align: middle;

    &.selectable {
      cursor: pointer;
    }

    &.white {
      background: #ffe090;

      &.selected {
        box-shadow: 0 0 15px 10px rgb(248, 255, 119);
      }
    }

    &.black {
      background: #713002;

      &.selected {
        box-shadow: 0 0 15px 10px #de9040;
      }
    }
  }
</style>
