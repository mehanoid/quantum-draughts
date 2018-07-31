<template lang="pug">
  div#app
    .current-player-message(
      :class="match.current_player"
    )
      | {{ currentPlayerMessage }}
    .app-layout
      GameBoard(:board="multiBoard")
      MatchHistory
</template>

<script>
import GameBoard from './GameBoard'
import MatchHistory from './MatchHistory'
import {mapGetters, mapState} from 'vuex'

export default {
  components: {
    GameBoard, MatchHistory
  },
  computed: {
    ...mapState(['boards', 'match']),
    ...mapGetters(['multiBoard']),
    currentPlayerMessage(){
      return `${_.capitalize(this.match.current_player)}'s turn`
    }
  },
  created() {
    this.matchesChannel = this.$cable.channels.match.subscribe(this.match.id)
  },
  beforeDestroy() {
    this.matchesChannel.unsubscribe()
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

.app-layout {
  display: flex;
  justify-content: center;
}

.board {
  margin-right: 40px
}
</style>
