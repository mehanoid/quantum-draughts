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
  margin-bottom: 5px;
  padding: 5px;
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
}

.draughts-chunk {
  --chunk-margin: 5px;
  --draughts-count: 3;

  width: calc(50% - var(--chunk-margin) * 2);
  display: flex;
  margin: 0 var(--chunk-margin);
}

.draught {
  --draught-size: 35px;

  margin: calc((100% - var(--draught-size) * var(--draughts-count)) / (var(--draughts-count) * 2));
}
</style>
