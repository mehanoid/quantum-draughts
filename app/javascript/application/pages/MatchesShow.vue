<template lang="pug">
  .matches-show
    v-alert.mb-4.alert(
      :value="disconnected"
      type="error"
      transition="scale-transition"
    ) {{ $t('errors.disconnected') }}
    v-layout(v-if="match" wrap)
      v-flex(xs12 md6 lg3)
        v-card.mb-2
          v-card-title {{ $t('matchesShow.matchInfo') }}
          MatchInfo
      v-flex(xs12 md6 lg6)
        MatchHeader.header
        v-layout(justify-center)
          GameBoard(
            :board="multiBoard"
          )
      v-flex(xs12 md6 lg3)
        v-card.pb-4.mb-2
          v-card-title {{ $t('matchesShow.beatenDraughts') }}
          GameBeaten
        v-card.pb-3.mb-2
          v-card-title {{ $t('matchesShow.matchHistory') }}
          MatchHistory
</template>

<script>
import GameBoard from '../components/GameBoard'
import MatchHistory from '../components/MatchHistory'
import GameDraught from '../components/GameDraught'
import GameBeaten from '../components/GameBeaten'
import MatchInfo from '../components/MatchInfo'
import {mapActions, mapGetters, mapMutations, mapState} from 'vuex'
import MatchHeader from '@application/components/MatchHeader'

export default {
  components: {
    GameBoard, MatchHistory, GameDraught, GameBeaten, MatchInfo, MatchHeader,
  },
  props: {
    matchId: {required: true, type: Number},
  },
  data() {
    return {
      disconnected: false
    }
  },
  computed: {
    ...mapState('gameplay', ['match']),
    ...mapGetters('gameplay', ['multiBoard']),
  },
  async created() {
    if (this.match && this.match.id !== this.matchId) {
      this.setMatch(null)
    }

    this.matchChannel = this.$cable.channels.match.subscribe(this.matchId, {
      received: this.setMatch.bind(this),
      connected: () => {
        if (this.disconnected) {
          this.updateMatch(this.matchId)
          this.disconnected = false
        }
      },
      disconnected: () => {
        this.disconnected = true
      }
    })
    await this.withPageLoader(async () => {
      this.updateMatch(this.matchId)
    })
  },
  beforeDestroy() {
    this.matchChannel.unsubscribe()
  },
  methods: {
    ...mapMutations('gameplay', ['setMatch']),
    ...mapActions('gameplay', ['updateMatch']),
    ...mapActions(['withPageLoader']),
  },
}
</script>

<style lang="postcss" scoped>
@import "../../stylesheets/media.css";

.matches-show {
  --board-padding: 25px;
}

.alert {
  position: sticky;
  top: 0;
  z-index: 1;
}

.header {
  margin-top: 20px;

  @media (--md) {
    margin-top: 0;
  }
}

</style>
