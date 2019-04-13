<template lang="pug">
  v-layout.matches-list
    v-flex
      v-data-table(
        :headers="headers"
        :items="matches"
        hide-actions
      )
        template(#items="{item: match}")
          td {{match.id}}
          td
            div(v-for="player in playersList(match)") {{ player }}
          td {{ $t(`rulesets.${match.ruleset}`) }}
          td.actions
            v-btn.deep-purple.accent-2.hide-on-hover-tr
              | {{ $t(`enums.match.statuses.${match.state}`) }}
            v-btn.deep-purple.accent-2.show-on-hover-tr(:to="matchUrl(match.id)")
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
    headers() {
      return [
        {text: '#', sortable: false},
        {text: this.$t('matchesList.players'), sortable: false},
        {text: this.$t('models.attributes.match.ruleset'), sortable: false},
        {text: this.$t('matchesList.state'), sortable: false},
      ]
    },
  },
  methods: {
    matchUrl(id) {
      return `/game/matches/${id}`
    },
    playerName(player) {
      return player && userUtils.displayingName(player)
    },
    playersList(match) {
      return [this.playerName(match.white_player), this.playerName(match.black_player)].filter(Boolean)
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

  & >>> table.v-table {
    & tr {
      &:hover {
        & .hide-on-hover-tr {
          display: none;
        }
      }

      &:not(:hover) {
        & .show-on-hover-tr {
          display: none;
        }
      }
    }
  }
}

.actions {
  min-width: 250px;
}

</style>
