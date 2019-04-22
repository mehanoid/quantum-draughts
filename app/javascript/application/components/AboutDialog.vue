<template lang="pug">
  v-dialog(
    :value="value"
    @input="$emit('input', $event)"
    width="800"
    lazy
  )
    v-card
      v-card-title Об игре
      v-card-text
        VuePerfectScrollbar.scroll-area
          AboutContent
      v-card-actions
        v-spacer
        v-btn.deep-purple.accent-2(
          @click="$emit('input', false)"
        ) {{ $t('buttons.close') }}
        v-spacer

</template>

<script>
import VuePerfectScrollbar from 'vue-perfect-scrollbar'
import AboutContent from './AboutContent'

export default {
  components: {VuePerfectScrollbar, AboutContent},
  props: {
    value: {type: Boolean, required: true}
  }
}
</script>

<style scoped>
.scroll-area {
  position: relative;
  max-height: 60vh;
}
</style>
