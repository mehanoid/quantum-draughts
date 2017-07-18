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

<style lang="postcss" scoped>
  .draught {
    display: inline-block;
    size: 40px;
    border-radius: 20px;
    vertical-align: middle;

    &.white {
      background: #ffe090;

      &.selected {
        box-shadow: 0 0 15px 10px rgb(248, 255, 119);
      }
    }

    &.black {
      background: #713002;

      &.selected {
        box-shadow: 0 0 15px 10px #de9040;
      }
    }
  }
</style>
