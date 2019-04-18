<template lang="pug">
  .game-beaten-draughts-group
    .draughts-chunk(v-for="draughtsLine in chunkedDraughts")
      GameBeatenDraught.draught(
        v-for="draught in draughtsLine"
        :key="draught.id"
        :draught="draught"
      )
</template>
<script>

import GameBeatenDraught from './GameBeatenDraught'

export default {
  components: {GameBeatenDraught},
  props: {
    draughts: {
      type: Array,
      required: true,
    },
  },
  computed: {
    chunkedDraughts() {
      return _.chunk(this.draughts, 3)
    },
  },
}
</script>

<style scoped>
.game-beaten-draughts-group {
  max-width: 285px;
  margin: 0 auto 10px;
  padding: 5px 12px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(2, 1fr);
  grid-gap: 8px 20px;
}

.draughts-chunk {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: 1fr;
  grid-gap: 8px;
}

.draught {
  --draught-size: 100%;
}
</style>
