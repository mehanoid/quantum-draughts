<template lang="pug">
  .match-history
    .table-wrap
      table.table
        tr
          th #
          th White
          th Black
        tr(v-for="matchTurn in turnGroups")
          th {{matchTurn[0].turn_number}}
          td
            MatchHistoryItem(:turn="matchTurn[0]")
          td
            MatchHistoryItem(v-if="matchTurn[1]" :turn="matchTurn[1]")
</template>

<script>
import {mapState} from 'vuex'
import MatchHistoryItem from './MatchHistoryItem'

export default {
  components: {
    MatchHistoryItem
  },
  computed: {
    ...mapState(['match']),
    turnGroups() {
      return _.reverse(_.chunk(this.match.match_turns, 2))
    }
  }
}
</script>

<style lang="postcss" scoped>
.table-wrap {
  overflow-y: auto;
  max-height: 300px;
}

.table {
  border-collapse: collapse;

  & th,
  & td {
    border: 1px solid black;
    padding: 5px;
  }
}
</style>
