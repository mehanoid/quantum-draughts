<template lang="pug">
  v-app(dark)
    v-toolbar
      v-toolbar-side-icon
      .logo
      v-toolbar-title.ml-2
        a.title(href="/") Quantum Draughts
    v-content
      component(:is="pageComponent")
    v-footer(app)
      v-layout(justify-center)
        | © 2018 Oleg Grigoriev

</template>

<script>
import MatchesShow from './pages/MatchesShow'
import MatchesIndex from './pages/MatchesIndex'

const components = {MatchesShow, MatchesIndex}

export default {
  components: components,
  props: {
    page: {type: String, required: true},
  },
  computed: {
    pageComponent() {
      return components[this.page]
    },
  },
}
</script>

<style scoped>

.logo {
  display: inline-block;
  width: 43px;
  height: 60%;
  background: url("~images/logo.svg") no-repeat;
  background-size: contain;
}

.title {
  color: white;
  text-decoration: none;
}

</style>
