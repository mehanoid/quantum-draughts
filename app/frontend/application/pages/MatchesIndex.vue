<template lang="pug">
  v-content
    v-container
      v-layout
        v-flex(xs6)
          | Matches list
          .match(
            v-for="match in matches"
          )
            a(:href="matchUrl(match.id)") {{match.id}}
          v-dialog(
            persistent
            v-model="showMatchForm"
            width="500"
          )
            v-btn(
              slot="activator"
            ) New match
            MatchForm(
              @close="showMatchForm = false"
            )
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
