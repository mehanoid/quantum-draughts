<template lang="pug">
  v-card
    v-card-title
      | {{ $t("matchForm.newMatch") }}
    v-card-text
      v-form
        v-radio-group(
          :label="$t('commons.ruleset')"
          v-model="match.ruleset"
        )
          v-radio(
            v-for="ruleset in rulesets"
            :key="ruleset.value"
            :label="ruleset.label"
            :value="ruleset.value"
          )
      v-card-actions
        v-spacer
        v-btn(
          @click="close"
        ) {{ $t("buttons.cancel") }}
        v-btn.deep-purple.accent-2(
          @click="saveMatch"
          :loading="progress"
        )
          | {{ $t("matchForm.start") }}
</template>

<script>
import {mapActions} from 'vuex'
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
        {value: 'english', label: this.$t('rulesets.english')},
        {value: 'russian', label: this.$t('rulesets.russian')},
      ]
    },
  },
  methods: {
    ...mapActions(['updateCurrentUser']),
    close() {
      this.$emit('close')
    },
    async saveMatch() {
      this.progress = true
      const response = await serverApi.matchCreate(this.match)
      const matchId = response.data.id
      this.updateCurrentUser()
      this.$router.push({name: 'match', params: {matchId}})
    },
  },
}
</script>
