<template lang="pug">
  .match-history
    VuePerfectScrollbar.scroll-area
      v-data-table(
        :headers="headers"
        :items="turnGroups"
        hide-actions
      )
        template(slot="items" slot-scope="{item}")
          td {{item[0].turn_number}}
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
    MatchHistoryItem, VuePerfectScrollbar,
  },
  computed: {
    ...mapState('gameplay', ['match']),
    turnGroups() {
      return _.chunk(this.match.match_turns, 2).reverse()
    },
    headers() {
      return [
        {text: '#', sortable: false, width: '5%'},
        {text: this.$t('commons.white'), sortable: false, width: '47.5%'},
        {text: this.$t('commons.black'), sortable: false, width: '47.5%'},
      ]
    },
  },
}
</script>

<style scoped>
.scroll-area {
  position: relative;
  margin: auto;
  height: 250px;
}

.match-history {
  & >>> table.v-table {
    & th,
    & td {
      padding: 16px;
    }
  }
}
</style>
