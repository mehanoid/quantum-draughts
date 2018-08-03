<template lang="pug">
  svg(:viewBox='viewBox')
    circle(
      v-if='isFull'
      cx='0'
      cy='0'
      :r='radius'
      :stroke='color'
      :stroke-width='strokeWidth'
      fill="transparent"
    )
    template(v-else)
      circle(
        cx='0'
        cy='0'
        :r='radius'
        :opacity="backgroundOpacity"
        :stroke='_backgroundColor'
        :stroke-width='strokeWidth'
        fill="transparent"
      )
      path(
        :d='arcPathD'
        :stroke='color'
        :stroke-width='strokeWidth'
        fill="transparent"
      )
</template>

<script>
export default {
  props: {
    percent: {
      type: Number,
      required: true
    },
    width: {
      type: Number,
      default: 1,
    },
    color: {
      type: String,
      required: true
    },
    backgroundColor: {
      type: String,
      default: undefined
    },
    backgroundOpacity: {
      type: Number,
      default: 0.5
    }
  },
  computed: {
    radius: () => 1,
    diameter() {
      return this.radius * 2
    },
    viewBox() {
      const width = this.diameter + this.strokeWidth
      const coordinate = -width / 2
      return `${coordinate} ${coordinate} ${width} ${width}`
    },
    strokeWidth() {
      return this.width * this.radius * 2
    },
    _backgroundColor() {
      return this.backgroundColor || this.color
    },
    isFull() {
      return this.percent === 100
    },
    arcPathD() {
      const degree = 2 * Math.PI * this.percent / 100
      const x = Math.sin(degree) * this.radius
      const y = -Math.cos(degree) * this.radius
      const largeArcFlag = x < 0 ? 1 : 0
      return `M 0 ${-this.radius} A ${this.radius} ${this.radius} 0 ${largeArcFlag} 1 ${x} ${y}`
    }
  }
}
</script>
