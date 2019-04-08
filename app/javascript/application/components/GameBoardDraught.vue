<template lang="pug">
  GameDraught(
    :draught="draught"
    :entanglementProbability="entanglementProbability"
    :canBeat="canBeat"
    :selected="isSelectedCell"
  )
</template>

<script>
import {mapGetters, mapState} from 'vuex'
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
    ...mapGetters('gameplay', ['entanglementInfo']),
    ...mapState('gameplay', ['match', 'selectedCellName']),
    draught() {
      return this.cell.draught
    },
    selectable() {
      return this.match.current_player_color === this.draught.color
    },
    isSelectedCell() {
      return this.selectedCellName === this.cell.name
    },
    canBeat(){
      return this.$store.getters['gameplay/canBeat'](this.cell.name)
    },
    entanglementProbability() {
      const info = this.entanglementInfo.find(i => i.cellName === this.cell.name)
      return info && info.probability
    },
  },
}
</script>
