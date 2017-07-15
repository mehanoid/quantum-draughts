<template lang="pug">
  div#app
    p {{ message }}
    .board-wrap
      Board(:board="currentBoard")
</template>

<script>
  import Board from './board/'
  import {mapGetters, mapState} from 'vuex'

  export default {
    data: function () {
      return {
        message: "Let the Game Begin"
      }
    },
    computed: {
      ...mapState(['boards']),
      ...mapGetters(['currentBoard']),
    },
    components: {
      Board
    }
  }
</script>

<style lang="postcss" scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
  .board-wrap{
    display: flex;
    justify-content: center;
  }
</style>
