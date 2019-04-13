<template lang="pug">
  .snackbars
    v-snackbar(
      v-if="snackbar"
      :timeout="snackbar.timeout"
      :color="snackbar.color"
      v-model="visible"
      bottom
      left
    )
      | {{ snackbar.text }}
      v-btn(
        flat
        @click="visible = false"
      )
        | {{ $t('buttons.close') }}
</template>

<script>

import {mapState} from 'vuex'

export default {
  components: {},
  data() {
    return {
    }
  },
  computed: {
    ...mapState('snackbars', ['snackbar']),
    visible: {
      get() {
        return this.$store.getters['snackbars/visible']
      },

      set(value) {
        return this.$store.dispatch('snackbars/setVisible', value)
      },
    },
  },
}
</script>
