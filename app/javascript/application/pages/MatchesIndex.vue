<template lang="pug">
  v-layout
    v-flex(xs6)
      h1 Matches list
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
      .match(
        v-for="match in matches"
      )
        router-link.light-blue--text.text--lighten-4(:to="matchUrl(match.id)") {{match.id}}
</template>

<script>
import {mapMutations} from 'vuex'
import MatchForm from '../components/MatchForm'
import serverApi from '../serverApi'

export default {
  components: {
    MatchForm,
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
