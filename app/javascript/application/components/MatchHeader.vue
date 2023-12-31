<template lang="pug">
  v-layout.board-header(justify-center)
    v-flex.player.player_white(xs4)
      GameDraught.player-draught(
        :draught="{color: 'white'}"
        :selected="highlightWhite"
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
        @click="joinToMatch"
      ) {{ $t("matchesShow.join") }}
      GuestWelcomeForm(
        v-model="showGuestWelcomeForm"
        @close="showGuestWelcomeForm = false"
        @success="joinToMatch"
      )
    v-flex.status-message(
      xs4
      v-else-if="isFinished"
    ) {{ matchFinishedMessage }}
    v-flex.status-message(
      xs4
      v-else
    ) {{ currentPlayerMessage }}
    v-flex.player.player_black(xs4)
      GameDraught.player-draught(
        :draught="{color: 'black'}"
        :selected="highlightBlack"
      )
      .player-name {{ playerName(match.black_player) }}
</template>

<script>

import {mapGetters, mapState, mapActions} from 'vuex'
import playerUtils from '@application/utils/player'
import GameDraught from './GameDraught'
import GuestWelcomeForm from './GuestWelcomeForm'

export default {
  components: {
    GameDraught, GuestWelcomeForm,
  },
  data() {
    return {
      showGuestWelcomeForm: false,
    }
  },
  computed: {
    ...mapState('gameplay', ['match']),
    ...mapGetters('gameplay', ['multiBoard', 'isCurrentPlayerParticipant', 'isCurrentPlayerTurn']),
    ...mapState(['currentPlayer']),

    isNewMatch() {
      return this.match.state === 'new_match'
    },

    isFinished() {
      return this.match.state === 'finished'
    },

    showJoinButton() {
      return this.isNewMatch && !this.isCurrentPlayerParticipant
    },

    highlightWhite() {
      if (this.isFinished) {
        return this.match.current_player_color === 'black'
      }
      else {
        return this.match.current_player_color === 'white'
      }
    },

    highlightBlack() {
      if (this.isFinished) {
        return this.match.current_player_color === 'white'
      }
      else {
        return this.match.current_player_color === 'black'
      }
    },

    currentPlayerMessage() {
      if (this.isCurrentPlayerTurn) {
        return this.$t('matchesShow.yourTurn')
      }
      else if (this.isCurrentPlayerParticipant) {
        return this.$t('matchesShow.opponentTurn')
      }
      else if (this.match.current_player_color === 'white') {
        return this.$t('matchesShow.whiteTurn')
      }
      else {
        return this.$t('matchesShow.blackTurn')
      }
    },

    matchFinishedMessage() {
      if (this.isCurrentPlayerTurn) {
        return this.$t('matchesShow.youLose')
      }
      else if (this.isCurrentPlayerParticipant) {
        return this.$t('matchesShow.youWon')
      }
      else if (this.match.current_player_color === 'white') {
        return this.$t('matchesShow.blackWon')
      }
      else {
        return this.$t('matchesShow.whiteWon')
      }
    }
  },
  methods: {
    ...mapActions('gameplay', ['join']),

    joinToMatch() {
      if (this.currentPlayer) {
        this.join()
      }
      else {
        this.showGuestWelcomeForm = true
      }
    },

    playerName(player) {
      return player && playerUtils.displayingName(player) || this.$t('matchesShow.noPlayer')
    },
  },
}
</script>

<style lang="postcss" scoped>
@import "../../stylesheets/media.css";

.board-header {
  padding: 0 var(--board-padding);
  margin: 0 auto 10px;
  height: 80px;

  @media (--lg) {
    width: 490px;
  }
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

.status-message {
  height: 30px;
  font-size: 1.2em;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
}
</style>
