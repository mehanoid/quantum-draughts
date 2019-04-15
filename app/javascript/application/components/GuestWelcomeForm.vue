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
            @click="submit"
            :loading="progress"
          )
            | {{ $t("buttons.next") }}
</template>

<script>
import {mapActions, mapState} from 'vuex'
import UserFormInputs from './UserFormInputs'
import serverApi from '@application/serverApi'

export default {
  components: {UserFormInputs},
  props: {
    value: {type: Boolean, required: true},
  },
  data: () => ({
    valid: true,
    user: {
      displaying_name: null,
    },
    progress: false,
  }),
  computed: {
    ...mapState(['currentUser']),
  },
  methods: {
    ...mapActions(['updateCurrentUser']),

    close() {
      this.$emit('close')
    },

    async submit() {
      if (!this.$refs.form.validate()) {
        return
      }

      const user = await serverApi.profileUpdate(this.user)
      this.$store.commit('setCurrentUser', user)
      this.$emit('success')
    },
  },
}
</script>
