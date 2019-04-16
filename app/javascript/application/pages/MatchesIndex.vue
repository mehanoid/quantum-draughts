<template lang="pug">
  v-layout
    v-flex(xs12 lg6)
      v-dialog(
        v-model="showMatchForm"
        width="500"
        lazy
      )
        v-btn.deep-purple.accent-2(
          slot="activator"
        ) {{ $t("matchesIndex.startGame") }}
        MatchForm(
          @close="showMatchForm = false"
        )
      v-tabs(
        v-if="allMatches !== null"
        v-model="currentTab"
      )
        v-tab(
        ) {{ $t('matchesIndex.tabs.allMatches') }}
        v-tab(
        )  {{ $t('matchesIndex.tabs.myMatches') }}
        v-tab-item(
        )
          MatchesList#sometab(:matches="allMatches")
        v-tab-item(
        )
          MatchesList(:matches="currentUserMatches")

</template>

<script>
import {mapMutations} from 'vuex'
import MatchForm from '../components/MatchForm'
import MatchesList from '../components/MatchesList'
import serverApi from '../serverApi'

const TABS = ['allMatches', 'myMatches']

export default {
  components: {
    MatchForm,
    MatchesList,
  },
  data() {
    return {
      allMatches: null,
      currentUserMatches: null,
      showMatchForm: false,
      currentTab: TABS.indexOf('allMatches'),
    }
  },

  computed: {},

  async created() {
    this.setPageLoading(true)
    const response = await serverApi.matchesGet()
    this.setPageLoading(false)
    this.allMatches = response.data.all_matches
    this.currentUserMatches = response.data.current_user_matches
    if (this.currentUserMatches.length) {
      this.currentTab = TABS.indexOf('myMatches')
    }
  },

  methods: {
    ...mapMutations(['setPageLoading']),
  },
}
</script>

<style scoped>

</style>
