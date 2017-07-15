<template lang="pug">
  .draught(
    v-if="draught",
    :class="[draught.color, {selected: selected}]",
    @click.stop="selectDraught(draught)"
  )
</template>

<script>
  import {mapActions, mapMutations} from "vuex"

  export default {
    data: function () {
      return {}
    },
    props: {
      draught: Object
    },
    computed: {
      selected(){
        return this.$store.state.selectedDraughtId === this.draught.id
      }
    },
    methods: {
      ...mapMutations(['selectDraught']),
    },
  }
</script>

<style src="./style.pcss" scoped></style>
