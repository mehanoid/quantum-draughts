<template lang="pug">
  v-app(dark)
    v-toolbar
      v-toolbar-side-icon
      .logo
      v-toolbar-title.ml-2
        router-link.title(to="/") Quantum Draughts
    v-content
      router-view
    v-footer(app)
      v-layout(justify-center)
        | © 2018 Oleg Grigoriev

</template>

<script>
export default {
  props: {
    page: {type: String, required: true},
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
