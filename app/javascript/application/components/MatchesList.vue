<template lang="pug">
  v-layout(wrap).matches-list
    v-flex.mt-2(xs12 v-for="match in matches" :key="match.id")
      v-card(:to="{ name: 'match', params: { matchId: match.id}}")
        v-card-title
          v-layout(wrap)
            v-flex(xs6)
              div {{`#${match.id} ${$t(`rulesetsFull.${match.ruleset}`)}`}}
              div.mt-1 {{ $t(`enums.match.statuses.${match.state}`) }}
            v-flex.players(xs6)
              div.player {{ playerName(match.white_player) }}
              div vs
              div.player {{ playerName(match.black_player) }}
            v-flex(xs6)
              v-btn.deep-purple.accent-2
                | {{ matchOpenButtonText(match) }}
    v-flex.mt-2(v-if="!matches.length")
      v-card
        v-card-title {{ $t('commons.noData') }}
</template>

<script>
import MatchForm from '../components/MatchForm'
import {mapState} from 'vuex'
import playerUtils from '@application/utils/player'

export default {
  components: {
    MatchForm,
  },
  props: {
    matches: {
      type: Array,
      required: true,
    },
  },
  computed: {
    ...mapState(['currentPlayer']),
  },
  methods: {
    playerName(player) {
      return player && playerUtils.displayingName(player) || this.$t('matchesShow.noPlayer')
    },
    matchOpenButtonText(match) {
      if (match.state === 'finished') {
        return this.$t('matchesList.showDetails')
      }
      if (this.currentPlayer && (match.white_player && match.white_player.id === this.currentPlayer.id ||
        match.black_player && match.black_player.id === this.currentPlayer.id)) {
        return this.$t('matchesList.backToGame')
      }
      if (match.state === 'new_match') {
        return this.$t('matchesList.join')
      }
      else {
        return this.$t('matchesList.watch')
      }
    },
  },
}
</script>

<style lang="postcss" scoped>
.players {
  text-align: center;
}

.player {
  font-size: 1.1em;
  font-weight: bold;
}

</style>
