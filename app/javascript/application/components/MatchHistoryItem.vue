<template lang="pug">
  a.light-blue--text.text--lighten-4(:class="classNames" href="#" @click.prevent="handleClick") {{moveString}}
</template>

<script>
import {mapState, mapMutations, mapActions} from 'vuex'

export default {
  components: {},
  props: {
    turn: {
      type: Object,
      required: true,
    },
  },
  computed: {
    ...mapState('gameplay/history', ['selectedMatchTurnId']),
    classNames() {
      return {
        'current-turn': this.currentTurn,
        'selected': (!this.selectedMatchTurnId && this.currentTurn) || this.turn.id === this.selectedMatchTurnId,
      }
    },
    moveString() {
      if (this.turn.move) {
        return this.turn.move.map(moveVar => {
          return _.toLower(moveVar.cells.join(moveVar.beat ? ':' : '-'))
        }).join(' | ')
      }
      else {
        return this.$t('matchHistory.currentTurn')
      }
    },
    currentTurn() {
      return !this.turn.move
    },
  },
  methods: {
    ...mapMutations('gameplay/history', ['setSelectedMatchTurn']),
    ...mapActions('gameplay/history', ['selectMatchTurn']),
    handleClick() {
      if (this.currentTurn) {
        this.setSelectedMatchTurn(null)
      }
      else {
        this.selectMatchTurn(this.turn.id)
      }
    },
  },
}
</script>

<style scoped>
.current-turn {
  font-style: italic;
}

.selected {
  font-weight: bold;
}
</style>
