<template lang="pug">
  v-app(dark)
    v-toolbar
      v-toolbar-side-icon
      .logo
      v-toolbar-title.ml-2
        a.title(href="/") Quantum Draughts
    v-content
      v-container
        v-layout
          v-flex(xs3)
            v-expansion-panel(expand v-model="leftPanels")
              v-expansion-panel-content(ripple)
                div(slot="header") Match info
                MatchInfo
          v-flex(xs6)
            v-layout(justify-center)
              .current-player-message
                | Current player:
                |
                GameDraught.current-player-draught(
                  :draught="{color: match.current_player}"
                )
            v-layout(justify-center)
              GameBoard(
                :board="multiBoard"
              )
          v-flex(xs3)
            v-expansion-panel(expand v-model="rightPanels")
              v-expansion-panel-content(ripple)
                div(slot="header") Match history
                MatchHistory
              v-expansion-panel-content(ripple)
                div(slot="header") Beaten draughts
                GameBeaten
    v-footer(app)
      v-layout(justify-center)
        | © 2018 Oleg Grigoriev

</template>

<script>
import GameBoard from './GameBoard'
import MatchHistory from './MatchHistory'
import GameDraught from './GameDraught'
import GameBeaten from './GameBeaten'
import MatchInfo from './MatchInfo'
import {mapGetters, mapState} from 'vuex'

export default {
  components: {
    GameBoard, MatchHistory, GameDraught, GameBeaten, MatchInfo,
  },
  data() {
    return {
      leftPanels: [true, true],
      rightPanels: [true, true],
    }
  },
  computed: {
    ...mapState(['boards', 'match']),
    ...mapGetters(['multiBoard']),
  },
  created() {
    this.matchesChannel = this.$cable.channels.match.subscribe(this.match.id)
  },
  beforeDestroy() {
    this.matchesChannel.unsubscribe()
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

.current-player-message {
  font-size: 2em;
  text-align: center;
  font-weight: bold;
}

.current-player-draught {
  --draught-size: 0.7em;

  display: inline-block;
}

</style>
