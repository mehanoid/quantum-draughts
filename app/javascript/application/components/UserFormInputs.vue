<template lang="pug">
  v-text-field(
    v-if="!currentUser"
    v-model="user.displaying_name"
    label="Ваше имя"
    :rules="userValidations.displayingNameRules"
    required
  )
</template>

<script>
import {mapState} from 'vuex'

export default {
  props: {
    value: {type: Object, required: true},
  },
  data() {
    return {
      user: null,
    }
  },
  computed: {
    ...mapState(['currentUser']),

    userValidations() {
      return {
        displayingNameRules: [
          v => !!v || this.$t('validation.errors.required'),
          v => (v && v.length <= 25) || this.$t('validation.errors.maxLength', {count: 25}),
        ],
      }
    },
  },
  watch: {
    user() {
      this.$emit('input', this.user)
    },
  },
  created() {
    this.user = this.value
  },
}
</script>
