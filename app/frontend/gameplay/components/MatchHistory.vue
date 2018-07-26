<template lang="pug">
  .match-history
    h3 Match history
    table
      tr(v-for="matchTurn in match.match_turns")
        td {{matchTurn.turn_number}}
        td {{matchTurn.last_move}}
</template>

<script>
  import {mapState} from 'vuex'

  export default {
    computed: {
      ...mapState(['match']),
    },
    components: {
    }
  }
</script>

<style lang="postcss" scoped>
</style>
