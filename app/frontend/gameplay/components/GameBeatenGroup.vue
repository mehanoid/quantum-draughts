<template lang="pug">
  .game-beaten-draughts-group
    GameBeatenDraught.draught(
      v-for="draught in draughts"
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
}
</script>

<style scoped>
.game-beaten-draughts-group {
  padding: 5px;
  border: 1px solid black;
  background: var(--clr-cell-playable);
}

.draught {
  display: inline-block;
}
</style>
