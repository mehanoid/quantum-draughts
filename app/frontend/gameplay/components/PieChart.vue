<template lang="pug">
  svg(:viewBox='viewBox')
    circle(cx='0', cy='0', r='1', stroke='#75806f', :stroke-width='strokeWidth / 5', opacity="0.5")
    path(v-if='!circle', :d='path', :stroke='color', :stroke-width='strokeWidth / 5', :opacity='opacity')
    circle(v-if='circle', cx='0', cy='0', r='1', :stroke='color', :stroke-width='strokeWidth / 5', :opacity='opacity')
</template>

<script>
  export default {
    name: 'pie-chart',
    props: {
      percent: {
        type: Number,
        default: 1
      },
      strokeWidth: {
        type: Number,
        default: 1,
      },
      color: {
        type: String,
        default: '#40a070'
      },
      opacity: {
        type: Number,
        default: 1
      }
    },
    computed: {
      width: function () {
        return 2 + this.strokeWidth / 5
      },
      viewBox: function () {
        let c = 1 + this.strokeWidth / 10
        let w = this.width
        return `${-c} ${-c} ${w} ${w}`
      },
      circle: function () {
        return this._ratio % 1 === 0
      },
      _ratio: function () {
        return this.percent / 100
      },
      arc: function () {
        let r = this._ratio  // short hand
        let deg = 2 * Math.PI * r
        let x = 1 * Math.sin(deg)
        let y = -1 * Math.cos(deg)
        let negative = r < 0
        let large = 0
        // 0 ccw, 1 clock-wise
        let rotation = negative ? 0 : 1
        if (negative && x > 0) {
          large = 1
        } else if (!negative && x < 0) {
          large = 1
        }
        return `A 1 1 0 ${large} ${rotation} ${x} ${y}`
      },
      path: function () {
        return `M 0 -1 ${this.arc}`
      }
    }
  }
</script>

<style scoped>
  svg path, svg circle {
    fill: transparent;
  }
</style>
