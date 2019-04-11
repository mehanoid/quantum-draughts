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
          td.actions
            v-btn.deep-purple.accent-2.hide-on-hover-tr
              | {{ $t(`enums.match.statuses.${match.state}`) }}
            v-btn.deep-purple.accent-2.show-on-hover-tr(:to="matchUrl(match.id)")
              template(v-if="match.state === 'new_match'") {{ $t('matchesList.join') }}
              template(v-else) {{ $t('matchesList.watch') }}
</template>

<script>
import MatchForm from '../components/MatchForm'

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
    headers() {
      return [
        {text: '#', sortable: false},
        {text: this.$t('matchesList.players'), sortable: false},
        {text: this.$t('matchesList.state'), sortable: false},
      ]
    },
  },
  methods: {
    matchUrl(id) {
      return `/game/matches/${id}`
    },
    playerName(player) {
      return player && this.$t('matchesShow.anonymousPlayerName', {id: player.id})
    },
    playersList(match) {
      return _.compact([this.playerName(match.white_player), this.playerName(match.black_player)])
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
