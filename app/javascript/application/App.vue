<template lang="pug">
  v-app(dark)
    v-toolbar
      .logo
      v-toolbar-title.ml-2.mr-3
        router-link.title(to="/") Quantum Draughts
      v-toolbar-items
        v-btn(flat to="/") {{ $t('menu.matches') }}
        v-btn(
          flat
          :to="{ name: 'about' }"
        ) {{ $t('aboutGame.title') }}
    v-content
      v-progress-linear.progress(
        v-if="pageLoading"
        :indeterminate="true"
      )
      v-container
        LayoutSnackbars
        router-view
    v-footer(app)
      v-layout(justify-center)
        | © 2019
        | {{ $t('copyright') }}
</template>

<script>
import {mapState} from 'vuex'
import LayoutSnackbars from './components/LayoutSnackbars'

export default {
  components: {LayoutSnackbars},
  data() {
    return {
    }
  },
  computed: {
    ...mapState(['pageLoading']),
  },
}
</script>

<style scoped>
.logo {
  display: inline-block;
  width: 43px;
  height: 60%;
  background: url("~images/logo.svg") no-repeat;
  background-size: contain;
}

.progress {
  position: absolute;
  margin-top: 0;
}

.title {
  color: white;
  text-decoration: none;
}
</style>
