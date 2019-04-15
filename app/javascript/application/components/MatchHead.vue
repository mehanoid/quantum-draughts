<template lang="pug">
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
</template>

<script>

import {mapGetters, mapState, mapActions} from 'vuex'
import userUtils from '@application/utils/user'
import GameDraught from '@application/components/GameDraught'

export default {
  components: {
    GameDraught,
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
  methods: {
    ...mapActions('gameplay', ['join']),

    playerName(player) {
      return player && userUtils.displayingName(player) || this.$t('matchesShow.noPlayer')
    },
  },
}
</script>

<style scoped>
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
