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
          a.new-match(href="/game/matches/new") New Match
</template>

<script>

export default {
  components: {
  },
  data() {
    return {
      matches: gon.matches,
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
