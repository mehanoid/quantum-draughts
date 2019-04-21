<template lang="pug">
  .matches-show
    v-alert.mb-4(
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
import {mapState, mapMutations, mapGetters, mapActions} from 'vuex'
import serverApi from '../serverApi'
import MatchHeader from '@application/components/MatchHeader'

export default {
  components: {
    GameBoard, MatchHistory, GameDraught, GameBeaten, MatchInfo, MatchHeader,
  },
  props: {
    matchId: {required: true},
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
    const id = parseInt(this.matchId)
    if (this.match && this.match.id !== id) {
      this.updateMatch(null)
    }
    this.matchChannel = this.$cable.channels.match.subscribe(id, {
      received: this.updateMatch.bind(this),
      disconnected: () => {
        this.disconnected = true
      },
    })
    await this.withPageLoader(async () => {
      const response = await serverApi.matchGet(id)
      this.updateMatch(response.data)
    })
  },
  beforeDestroy() {
    this.matchChannel.unsubscribe()
  },
  methods: {
    ...mapMutations('gameplay', ['updateMatch']),
    ...mapActions(['withPageLoader']),
  },
}
</script>

<style scoped>
@import "../../stylesheets/media.css";

.matches-show {
  --board-padding: 25px;
}

.header {
  margin-top: 20px;

  @media (--md) {
    margin-top: 0;
  }
}

</style>
