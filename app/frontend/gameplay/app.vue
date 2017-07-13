<template lang="pug">
  div#app
    p {{ message }}
    Board(v-for="board in boards", :board="board")
</template>

<script>
  import Board from './components/board'
  import {mapState} from 'vuex'

  export default {
    data: function () {
      return {
        message: "Let the Game Begin"
      }
    },
    computed: mapState(['boards']),
    components: {
      Board
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
