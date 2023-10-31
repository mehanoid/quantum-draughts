<template lang="pug">
  v-text-field(
    v-if="!currentPlayer"
    v-model="player.displaying_name"
    label="Ваше имя"
    :rules="playerValidations.displayingNameRules"
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
      player: null,
    }
  },
  computed: {
    ...mapState(['currentPlayer']),

    playerValidations() {
      return {
        displayingNameRules: [
          v => !!(v && v.trim()) || this.$t('validation.errors.required'),
          v => (v && v.length <= 25) || this.$t('validation.errors.maxLength', {count: 25}),
        ],
      }
    },
  },
  watch: {
    player() {
      this.$emit('input', this.player)
    },
  },
  created() {
    this.player = this.value
  },
}
</script>
