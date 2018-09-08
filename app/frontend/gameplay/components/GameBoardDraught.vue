<template lang="pug">
  GameDraught(
    :draught="draught"
    :entanglementProbability="entanglementProbability"
    :canBeat="canBeat"
    :selected="isSelectedCell"
  )
</template>

<script>
import {mapGetters} from 'vuex'
import GameDraught from './GameDraught'

export default {
  components: {GameDraught},
  props: {
    cell: {
      type: Object,
      required: true,
    },
  },
  computed: {
    ...mapGetters(['entanglementInfo']),
    draught() {
      return this.cell.draught
    },
    selectable() {
      return this.$store.state.match.current_player === this.draught.color
    },
    isSelectedCell() {
      return this.$store.state.selectedCellName === this.cell.name
    },
    canBeat(){
      return this.$store.getters.canBeat(this.cell.name)
    },
    entanglementProbability() {
      const info = this.entanglementInfo.find(i => i.cellName === this.cell.name)
      return info && info.probability
    },
  },
}
</script>
