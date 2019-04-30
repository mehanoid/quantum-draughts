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
        UserFormInputs(
          v-model="user"
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
import UserFormInputs from './UserFormInputs'

export default {
  components: {UserFormInputs},
  data: () => ({
    valid: true,
    match: {
      ruleset: 'english',
    },
    user: {
      displaying_name: null,
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
      this.$refs.form.resetValidation()
      this.$emit('close')
    },
    async saveMatch() {
      if(!this.$refs.form.validate()) {
        return
      }

      this.progress = true
      const response = await serverApi.matchCreate({game_match: this.match, user: this.user})
      const matchId = response.data.id
      this.updateCurrentUser()
      this.$router.push({name: 'match', params: {matchId}})
    },
  },
}
</script>
