<template lang="pug">
  v-layout
    v-flex
      v-data-table(
        :headers="headers"
        :items="matches"
        hide-actions
      )
        template(#items="{item: match}")
          td {{match.id}}
          td
          td
            router-link.light-blue--text.text--lighten-4(:to="matchUrl(match.id)") {{match.state}}
</template>

<script>
import MatchForm from '../components/MatchForm'

export default {
  components: {
    MatchForm,
  },
  props: {
    matches: {
      type: Array,
      required: true,
    },
  },
  computed: {
    headers() {
      return [
        {text: '#', sortable: false},
        {text: this.$t('matchesList.players'), sortable: false},
        {text: this.$t('matchesList.state'), sortable: false},
      ]
    },
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
