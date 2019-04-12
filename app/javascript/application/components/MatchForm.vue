<template lang="pug">
  v-card
    v-card-title
      | {{ $t("matchForm.newMatch") }}
    v-card-text
      v-form(
        ref="form"
        v-model="valid"
        lazy-validation
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
        v-text-field(
          v-if="!currentUser"
          v-model="user.displaying_name"
          label="Ваше имя"
          :rules="userValidations.displayingNameRules"
          required
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
import {mapActions, mapState} from 'vuex'
import serverApi from '../serverApi'

export default {
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
    ...mapState(['currentUser']),

    rulesets() {
      return [
        {value: 'english', label: this.$t('rulesets.english')},
        {value: 'russian', label: this.$t('rulesets.russian')},
      ]
    },

    userValidations() {
      return {
        displayingNameRules: [
          v => !!v || this.$t('validation.errors.required'),
          v => (v && v.length <= 25) || this.$t('validation.errors.maxLength', {count: 25}),
        ],
      }
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
