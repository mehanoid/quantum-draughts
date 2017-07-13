<template lang="pug">
  table.board
    tr(v-for="row in board")
      td(v-for="cell in row") {{ cell.object }}

</template>

<script>
  export default {
    data: function () {
      return {}
    },
    props: {
      board: Object
    }
  }
</script>

<style scoped>
  td{
    border: 1px solid black;
    width: 20px;
    height: 20px;
  }
</style>
