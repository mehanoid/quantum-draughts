<template lang="pug">
  div#app
    .current-player-message(
      :class="match.current_player"
    )
      | {{ currentPlayerMessage }}
    .board-wrap
      GameBoard(:board="multiBoard")
    MatchHistory
</template>

<script>
  import GameBoard from './GameBoard'
  import MatchHistory from './MatchHistory'
  import {mapGetters, mapState} from 'vuex'

  export default {
    computed: {
      ...mapState(['boards', 'match']),
      ...mapGetters(['multiBoard']),
      currentPlayerMessage(){
        return `${_.capitalize(this.match.current_player)}'s turn`
      }
    },
    components: {
      GameBoard, MatchHistory
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
