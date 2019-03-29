import matchChannel from './channels/matchChannel'
import Vue from 'vue'

export default function ({store}) {
  Object.defineProperty(Vue.prototype, '$cable', {
    get: function () {
      return this.$root.$options.cable
    },
  })

  if (process.env.NODE_ENV !== 'production') {
    ActionCable.startDebugging()
  }

  const consumer = ActionCable.createConsumer()
  const cable = {
    ...consumer,
    consumer,
    store,
    channels: {},
  }

  cable.channels = {
    match: matchChannel(cable),
  }

  return cable
}
