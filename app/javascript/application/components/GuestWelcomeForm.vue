<template lang="pug">
  v-dialog(
    :value="value"
    @input="$emit('input', $event)"
    width="500"
    lazy
  )
    v-card
      v-card-title
        | {{ $t("guestWelcomeForm.title") }}
      v-card-text
        v-form(
          ref="form"
          v-model="valid"
          lazy-validation
          @submit.prevent="submit"
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
          @click="submit"
          :loading="progress"
        )
          | {{ $t("buttons.next") }}
</template>

<script>
import {mapActions, mapState} from 'vuex'
import PlayerFormInputs from './PlayerFormInputs'
import serverApi from '@application/serverApi'

export default {
  components: {PlayerFormInputs},
  props: {
    value: {type: Boolean, required: true},
  },
  data: () => ({
    valid: true,
    player: {
      displaying_name: null,
    },
    progress: false,
  }),
  computed: {
    ...mapState(['currentPlayer']),
  },
  methods: {
    ...mapActions(['updateCurrentPlayer']),

    close() {
      this.$emit('close')
    },

    async submit() {
      if (!this.$refs.form.validate()) {
        return
      }

      const player = await serverApi.currentPlayerUpdate(this.player)
      this.$store.commit('setCurrentPlayer', player)
      this.$emit('success')
    },
  },
}
</script>
