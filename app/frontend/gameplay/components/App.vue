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
          v-flex(xs12)
            .current-player-message(
            :class="`${match.current_player}-player`"
            )
              | {{ currentPlayerMessage }}
        v-layout
          v-flex(xs8)
            v-layout(justify-center)
              GameBoard(
                :board="multiBoard"
              )
          v-flex(xs4)
            .ruleset Ruleset: {{match.ruleset}}
            v-expansion-panel(expand v-model="panels")
              v-expansion-panel-content(ripple)
                div(slot="header") MatchHistory
                v-card
                  v-card-text
                    MatchHistory
              v-expansion-panel-content(ripple)
                div(slot="header") GameBeatenDraughts
                v-card
                  v-card-text
                    GameBeatenDraughts
    v-footer(app)
      v-layout(justify-center)
        | © 2018 Oleg Grigoriev

</template>

<script>
import GameBoard from './GameBoard'
import MatchHistory from './MatchHistory'
import GameBeaten from './GameBeaten'
import {mapGetters, mapState} from 'vuex'

export default {
  components: {
    GameBoard, MatchHistory, GameBeatenDraughts: GameBeaten,
  },
  data() {
    return {
      panels: [true, true],
    }
  },
  computed: {
    ...mapState(['boards', 'match']),
    ...mapGetters(['multiBoard']),
    currentPlayerMessage() {
      return `${_.capitalize(this.match.current_player)}'s turn`
    },
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

  &.white-player {
    color: var(--clr-draught-white);
  }

  &.black-player {
    color: var(--clr-draught-black);
  }
}
</style>
