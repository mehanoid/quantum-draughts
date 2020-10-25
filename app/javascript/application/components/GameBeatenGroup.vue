<template lang="pug">
  .game-beaten-draughts-group(v-if="this.draughts.length")
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

<style lang="postcss" scoped>
.game-beaten-draughts-group {
  max-width: 285px;
  margin: 0 auto;
  padding: 0 16px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(auto-fill, 1fr);
  grid-gap: 8px 20px;

  &:not(:last-child) {
    margin-bottom: 20px;
  }
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
