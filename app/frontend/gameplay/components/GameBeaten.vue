<template lang="pug">
  .game-beaten
    GameBeatenDraughtsGroup(:draughts="beatenWhite")
    GameBeatenDraughtsGroup(:draughts="beatenBlack")
</template>
<script>

import {mapGetters} from 'vuex'
import GameBeatenGroup from './GameBeatenGroup'

export default {
  components: {GameBeatenDraughtsGroup: GameBeatenGroup},
  computed: {
    ...mapGetters('draughts', ['beatenWhite', 'beatenBlack']),
  }
}
</script>

<style scoped>
  .game-beaten {
    width: 180px;
  }
</style>
