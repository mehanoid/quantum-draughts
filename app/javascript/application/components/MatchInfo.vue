<template lang="pug">
  .match-info
    v-data-table.info-table(
      hide-headers
      :items="items"
      hide-actions
    )
      template(slot="items" slot-scope="{item}")
        td.info-title {{item.title}}
        td.info-value {{item.value}}
</template>

<script>
import {mapState} from 'vuex'

export default {
  components: {
  },
  computed: {
    ...mapState('gameplay', ['match']),
    items() {
      return [
        {title: 'Ruleset', value: _.capitalize(this.match.ruleset)},
      ]
    },
  },
}
</script>

<style scoped>

.info-title,
.info-value {
  padding: 16px;
}

.info-title {
  text-align: left;
}

.info-value {
  text-align: right;
}

.info-table {
  & >>> table.v-table {
    & th,
    & td {
      padding: 16px;
    }
  }
}

</style>
