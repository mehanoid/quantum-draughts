<template lang="pug">
  v-layout(v-if="match")
    v-flex(xs3)
      v-card.mb-2
        v-card-title Match info
        MatchInfo
    v-flex(xs6)
      v-layout(justify-center)
        v-flex
          v-layout(
            justify-center
            align-center
            v-if="match.state === 'new_match'"
          )
            span.state {{ $t("matchesShow.waitingForPlayers") }}
            v-btn.deep-purple.accent-2(
              @click="join"
            ) {{ $t("matchesShow.join") }}
          v-layout(
            v-else
          )
            v-flex
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
      v-card.pb-4.mb-2
        v-card-title Match history
        MatchHistory
      v-card.pb-3.mb-2
        v-card-title Beaten draughts
        GameBeaten
</template>

<script>
import GameBoard from '../components/GameBoard'
import MatchHistory from '../components/MatchHistory'
import GameDraught from '../components/GameDraught'
import GameBeaten from '../components/GameBeaten'
import MatchInfo from '../components/MatchInfo'
import {mapGetters, mapState, mapMutations, mapActions} from 'vuex'
import serverApi from '../serverApi'

export default {
  components: {
    GameBoard, MatchHistory, GameDraught, GameBeaten, MatchInfo,
  },
  props: {
    matchId: {type: String, required: true},
  },
  data() {
    return {}
  },
  computed: {
    ...mapState(['match']),
    ...mapGetters(['multiBoard']),
  },
  async created() {
    const id = parseInt(this.matchId)
    if (this.match && this.match.id !== id) {
      this.updateMatch(null)
    }
    this.matchChannel = this.$cable.channels.match.subscribe(id)
    this.setPageLoading(true)
    const response = await serverApi.matchGet(id)
    this.setPageLoading(false)
    this.updateMatch(response.data)
  },
  beforeDestroy() {
    this.matchChannel.unsubscribe()
  },
  methods: {
    ...mapMutations(['updateMatch', 'setPageLoading']),
    ...mapActions(['join']),
  },
}
</script>

<style scoped>

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
