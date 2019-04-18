<template lang="pug">
  v-layout(wrap).matches-list
    v-flex.mt-2(xs12 v-for="match in matches" :key="match.id")
      v-card(:to="matchUrl(match.id)")
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
</template>

<script>
import MatchForm from '../components/MatchForm'
import {mapState} from 'vuex'
import userUtils from '@application/utils/user'

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
    ...mapState(['currentUser']),
  },
  methods: {
    matchUrl(id) {
      return `/game/matches/${id}`
    },
    playerName(player) {
      return player && userUtils.displayingName(player) || this.$t('matchesShow.noPlayer')
    },
    matchOpenButtonText(match) {
      if (this.currentUser && (match.white_player && match.white_player.id === this.currentUser.id ||
        match.black_player && match.black_player.id === this.currentUser.id)) {
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

<style scoped>

.matches-list {
}

.players {
  text-align: center;
}

.player {
  font-size: 1.1em;
  font-weight: bold;
}

</style>
