<template lang="pug">
  v-card
    v-card-title
      | {{ $t("matchForm.newMatch") }}
    v-card-text
      v-form(
        ref="form"
        v-model="valid"
        lazy-validation
        @submit.prevent="saveMatch"
      )
        v-radio-group(
          :label="$t('models.attributes.match.ruleset')"
          v-model="match.ruleset"
        )
          v-radio(
            v-for="ruleset in rulesets"
            :key="ruleset.value"
            :label="ruleset.label"
            :value="ruleset.value"
          )
        PlayerFormInputs(
          v-model="player"
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
import PlayerFormInputs from './PlayerFormInputs'

export default {
  components: {PlayerFormInputs},
  data: () => ({
    valid: true,
    match: {
      ruleset: 'english',
    },
    player: {
      displaying_name: null,
    },
    progress: false,
  }),
  computed: {
    rulesets() {
      return [
        {value: 'english', label: this.$t('matchForm.rulesets.english')},
        {value: 'russian', label: this.$t('matchForm.rulesets.russian')},
      ]
    },
  },
  methods: {
    ...mapActions(['updateCurrentPlayer']),

    close() {
      this.$refs.form.resetValidation()
      this.$emit('close')
    },
    async saveMatch() {
      if(!this.$refs.form.validate()) {
        return
      }

      this.progress = true
      const response = await serverApi.matchCreate({game_match: this.match, player: this.player})
      const matchId = response.data.id
      this.updateCurrentPlayer()
      this.$router.push({name: 'match', params: {matchId}})
    },
  },
}
</script>
