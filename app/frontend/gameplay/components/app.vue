<template lang="pug">
  div#app
    .current-player-message(
      :class="currentPlayer"
    )
      | {{ currentPlayerMessage }}
    .board-wrap
      Board(:board="currentBoard")
</template>

<script>
  import Board from './board/'
  import {mapGetters, mapState} from 'vuex'

  export default {
    data: function () {
      return {
      }
    },
    computed: {
      ...mapState(['boards', 'currentPlayer']),
      ...mapGetters(['currentBoard']),
      currentPlayerMessage(){
        return `${_.capitalize(this.currentPlayer)}'s turn`
      }
    },
    components: {
      Board
    }
  }
</script>

<style lang="postcss" scoped>
  .current-player-message {
    font-size: 2em;
    text-align: center;
    font-weight: bold;

    &.white {
      color: #ffe090;
      text-stroke: 1 #878787;
    }

    &.black {
      color: #713002;
    }
  }
  .board-wrap{
    display: flex;
    justify-content: center;
  }
</style>
