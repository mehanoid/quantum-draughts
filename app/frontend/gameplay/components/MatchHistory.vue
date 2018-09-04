<template lang="pug">
  .match-history
    VuePerfectScrollbar.scroll-area
      v-data-table(
        :headers="headers"
        :items="turnGroups"
        hide-actions
      )
        template(slot="items" slot-scope="{item}")
          th {{item[0].turn_number}}
          td
            MatchHistoryItem(:turn="item[0]")
          td
            MatchHistoryItem(v-if="item[1]" :turn="item[1]")
</template>

<script>
import {mapState} from 'vuex'
import MatchHistoryItem from './MatchHistoryItem'
import VuePerfectScrollbar from 'vue-perfect-scrollbar'

export default {
  components: {
    MatchHistoryItem, VuePerfectScrollbar
  },
  computed: {
    ...mapState(['match']),
    turnGroups() {
      return _.reverse(_.chunk(this.match.match_turns, 2))
    },
    headers() {
      return [
        {text: '#', sortable: false, width: '5%'},
        {text: 'White', sortable: false, width: '45%'},
        {text: 'Black', sortable: false, width: '45%'},
      ]
    }
  }
}
</script>

<style lang="postcss" scoped>
.scroll-area {
  position: relative;
  margin: auto;
  height: 300px;
}
</style>
