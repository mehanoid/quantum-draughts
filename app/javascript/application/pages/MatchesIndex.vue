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
        v-if="currentMatches !== null"
        v-model="currentTab"
      )
        v-tab(
        ) {{ $t('matchesIndex.tabs.currentMatches') }}
        v-tab(
        )  {{ $t('matchesIndex.tabs.myMatches') }}
        v-tab-item(
        )
          MatchesList#sometab(:matches="currentMatches")
        v-tab-item(
        )
          MatchesList(:matches="currentPlayerMatches")

</template>

<script>
import {mapActions} from 'vuex'
import MatchForm from '../components/MatchForm'
import MatchesList from '../components/MatchesList'
import serverApi from '../serverApi'

const TABS = ['currentMatches', 'myMatches']

export default {
  components: {
    MatchForm,
    MatchesList,
  },
  data() {
    return {
      currentMatches: null,
      currentPlayerMatches: null,
      showMatchForm: false,
      currentTab: TABS.indexOf('currentMatches'),
    }
  },

  computed: {},

  async created() {
    await this.withPageLoader(async () => {
      const response = await serverApi.matchesGet()
      this.currentMatches = response.data.current_matches
      this.currentPlayerMatches = response.data.current_player_matches
    })

    if (this.currentPlayerMatches.length) {
      this.currentTab = TABS.indexOf('myMatches')
    }
  },

  methods: {
    ...mapActions(['withPageLoader']),
  },
}
</script>
