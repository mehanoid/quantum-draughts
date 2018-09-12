<template lang="pug">
  v-card
    v-card-title
      | New match
    v-card-text
      v-form
        v-radio-group(
          label="Ruleset"
          v-model="match.ruleset"
        )
          v-radio(
            v-for="ruleset in rulesets"
            :v-key="ruleset.value"
            :label="ruleset.label"
            :value="ruleset.value"
          )
      v-card-actions
        v-spacer
        v-btn(
          @click="close"
        ) Cancel
        v-btn(
          @click="saveMatch"
          :loading="progress"
        )
          | Create
</template>

<script>
import serverApi from '../serverApi'

export default {
  data: () => ({
    match: {
      ruleset: 'english',
    },
    progress: false,
  }),
  computed: {
    rulesets() {
      return [
        {value: 'english', label: 'English'},
        {value: 'russian', label: 'Russian'},
      ]
    },
  },
  methods: {
    close() {
      this.$emit('close')
    },
    async saveMatch() {
      this.progress = true
      const response = await serverApi.matchCreate(this.match)
      const matchId = response.data.id
      window.location = `/game/matches/${matchId}`
    },
  },
}
</script>
