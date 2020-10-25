<template lang="pug">
  v-app(dark)
    v-navigation-drawer(
      v-model="drawer"
      absolute
      temporary
    )
      v-list
        v-list-tile(to="/")
          v-list-tile-content
            v-list-tile-title {{ $t('menu.matches') }}
      v-list
        v-list-tile(:to="{ name: 'about' }")
          v-list-tile-content
            v-list-tile-title {{ $t('aboutGame.title') }}
    v-toolbar
      v-toolbar-side-icon.hidden-lg-and-up(
        @click="drawer = true"
      )
      .logo
      v-toolbar-title.ml-2.mr-3
        router-link.title(to="/") Quantum Draughts
      v-toolbar-items.hidden-md-and-down
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
        | © 2020
        | {{ $t('copyright') }}
</template>

<script>
import {mapState} from 'vuex'
import LayoutSnackbars from './components/LayoutSnackbars'

export default {
  components: {LayoutSnackbars},
  data() {
    return {
      drawer: false
    }
  },
  computed: {
    ...mapState(['pageLoading']),
  },
}
</script>

<style lang="postcss" scoped>
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
