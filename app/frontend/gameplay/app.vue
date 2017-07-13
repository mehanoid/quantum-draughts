<template lang="pug">
  div#app
    p {{ message }}
</template>

<script>
export default {
  data: function () {
    return {
      message: "Let the Game Begin"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
