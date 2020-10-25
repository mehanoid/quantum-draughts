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
        {title: this.$t('models.attributes.match.ruleset'), value: this.$t(`rulesets.${this.match.ruleset}`)},
        {title: this.$t('models.attributes.match.startedAt'), value: this.match.started_at},
        {title: this.$t('models.attributes.match.finishedAt'), value: this.match.finished_at},
      ].filter(({value}) => value)
    },
  },
}
</script>

<style lang="postcss" scoped>

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
