<template lang="pug">
  v-content
    v-container
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
            ) New match
            MatchForm(
              @close="showMatchForm = false"
            )
          .match(
            v-for="match in matches"
          )
            router-link(:to="matchUrl(match.id)") {{match.id}}
</template>

<script>
import MatchForm from '../components/MatchForm'

export default {
  components: {
    MatchForm,
  },
  data() {
    return {
      matches: gon.matches,
      showMatchForm: false,
    }
  },
  computed: {
  },
  methods: {
    matchUrl(id) {
      return `/game/matches/${id}`
    },
  },
}
</script>

<style scoped>

</style>
