<template lang="pug">
  v-layout.matches-show(v-if="match" wrap)
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
import {mapState, mapMutations, mapGetters} from 'vuex'
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
    return {}
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
  },
}
</script>

<style scoped>

@import "../../stylesheets/media.css";

.header {
  margin-top: 20px;

  @media (--md) {
    margin-top: 0;
  }
}

.matches-show {
  --board-padding: 25px;
}

</style>
