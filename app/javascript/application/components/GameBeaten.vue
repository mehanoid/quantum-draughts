<template lang="pug">
  .game-beaten
    GameBeatenDraughtsGroup(:draughts="draughtsBeatenWhite")
    GameBeatenDraughtsGroup(:draughts="draughtsBeatenBlack")
</template>
<script>

import {mapGetters} from 'vuex'
import GameBeatenGroup from './GameBeatenGroup'

export default {
  components: {GameBeatenDraughtsGroup: GameBeatenGroup},
  computed: {
    ...mapGetters('gameplay', ['draughtsBeatenWhite', 'draughtsBeatenBlack']),
  },
}
</script>
