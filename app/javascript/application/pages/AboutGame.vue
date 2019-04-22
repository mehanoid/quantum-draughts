<template lang="pug">
  v-layout(justify-center)
    v-flex(xs12 md8)
      h1 {{ $t('aboutGame.title') }}
      AboutContent
</template>

<script>
import AboutContent from '@application/components/AboutContent'

export default {
  components: {AboutContent}
}
</script>

