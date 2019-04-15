<template lang="pug">
  v-layout.matches-show(v-if="match")
    v-flex(xs3)
      v-card.mb-2
        v-card-title {{ $t('matchesShow.matchInfo') }}
        MatchInfo
    v-flex(xs6)
      v-layout.board-header(justify-center)
        v-flex.player.player_white(xs4)
          GameDraught.player-draught(
            :draught="{color: 'white'}"
            :selected="match.current_player_color==='white'"
          )
          .player-name {{ playerName(match.white_player) }}
        v-flex.waiting-for-players(
          xs4
          v-if="isNewMatch"
          justify-center
          align-center
        )
          span.waiting-for-players__text {{ $t("matchesShow.waitingForPlayers") }}
          v-btn.deep-purple.accent-2(
            v-if="showJoinButton"
            @click="join"
          ) {{ $t("matchesShow.join") }}
        v-flex.current-player-message(
          xs4
          v-else
        ) {{ currentPlayerMessage }}
        v-flex.player.player_black(xs4)
          GameDraught.player-draught(
            :draught="{color: 'black'}"
            :selected="match.current_player_color==='black'"
          )
          .player-name {{ playerName(match.black_player) }}
      v-layout(justify-center)
        GameBoard(
          :board="multiBoard"
        )
    v-flex(xs3)
      v-card.pb-4.mb-2
        v-card-title {{ $t('matchesShow.matchHistory') }}
        MatchHistory
      v-card.pb-3.mb-2
        v-card-title {{ $t('matchesShow.beatenDraughts') }}
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
import userUtils from '@application/utils/user'

export default {
  components: {
    GameBoard, MatchHistory, GameDraught, GameBeaten, MatchInfo,
  },
  props: {
    matchId: {required: true},
  },
  data() {
    return {}
  },
  computed: {
    ...mapState('gameplay', ['match']),
    ...mapGetters('gameplay', ['multiBoard', 'isCurrentUserParticipant', 'isCurrentUserTurn']),
    ...mapState(['currentUser']),

    isNewMatch() {
      return this.match.state === 'new_match'
    },

    showJoinButton() {
      return this.isNewMatch && !this.isCurrentUserParticipant
    },

    currentPlayerMessage() {
      if (this.isCurrentUserTurn) {
        return this.$t('matchesShow.yourTurn')
      }
      else if (this.isCurrentUserParticipant) {
        return this.$t('matchesShow.opponentTurn')
      }
      else if (this.match.current_player_color === 'white') {
        return this.$t('matchesShow.whiteTurn')
      }
      else {
        return this.$t('matchesShow.blackTurn')
      }
    },
  },
  async created() {
    const id = parseInt(this.matchId)
    if (this.match && this.match.id !== id) {
      this.updateMatch(null)
    }
    this.matchChannel = this.$cable.channels.match.subscribe(id, {
      received: (data) => this.updateMatch(data),
    })
    this.setPageLoading(true)
    const response = await serverApi.matchGet(id)
    this.setPageLoading(false)
    this.updateMatch(response.data)
  },
  beforeDestroy() {
    this.matchChannel.unsubscribe()
  },
  methods: {
    ...mapMutations('gameplay', ['updateMatch']),
    ...mapMutations(['setPageLoading']),
    ...mapActions('gameplay', ['join']),

    playerName(player) {
      return player && userUtils.displayingName(player) || this.$t('matchesShow.noPlayer')
    },
  },
}
</script>

<style scoped>

.matches-show {
  --board-padding: 25px;
}

.board-header {
  width: 490px;
  padding: 0 var(--board-padding);
  margin: 0 auto 10px;
  height: 80px;
}

.player {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.player_black {
  text-align: right;
}

.player-draught {
  --draught-size: 30px;

  display: inline-block;
}

.player-name {
  margin-top: 10px;
  text-align: center;
}

.waiting-for-players {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
}

.waiting-for-players__text {
  text-align: center;
}

.current-player-message {
  height: 30px;
  font-size: 1.2em;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
}

</style>
