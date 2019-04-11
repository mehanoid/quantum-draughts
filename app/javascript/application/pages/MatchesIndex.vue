<template lang="pug">
  v-layout
    v-flex(xs6)
      v-dialog(
        persistent
        v-model="showMatchForm"
        width="500"
      )
        v-btn.deep-purple.accent-2(
          slot="activator"
        ) {{ $t("matchesIndex.startGame") }}
        MatchForm(
          @close="showMatchForm = false"
        )
      h1 {{ $t('matchesIndex.currentMatches') }}
      MatchesList(:matches="matches")
</template>

<script>
import {mapMutations} from 'vuex'
import MatchForm from '../components/MatchForm'
import MatchesList from '../components/MatchesList'
import serverApi from '../serverApi'

export default {
  components: {
    MatchForm,
    MatchesList,
  },
  data() {
    return {
      matches: [],
      showMatchForm: false,
    }
  },
  computed: {
  },
  async created() {
    this.setPageLoading(true)
    const response = await serverApi.matchesGet()
    this.setPageLoading(false)
    this.matches = response.data
  },
  methods: {
    ...mapMutations(['setPageLoading']),
    matchUrl(id) {
      return `/game/matches/${id}`
    },
  },
}
</script>

<style scoped>

</style>
