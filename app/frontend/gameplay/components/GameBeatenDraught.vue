<template lang="pug">
  GameDraught.draught(
    :draught="draught"
    @click.native="selectDraught(draught)"
  )
</template>
<script>

import {mapActions} from 'vuex'
import GameDraught from './GameDraught'

export default {
  components: {GameDraught},
  props: {
    draught: {
      type: Object,
      required: true,
    },
  },
  methods: {
    ...mapActions(['selectDraught']),
  },
}
</script>

<style scoped>
.draught {
  --draught-size: 25px;
}
</style>
