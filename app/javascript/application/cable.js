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
    consumer,
    store,
    channels: {},
  }

  cable.channels = {
    match: {
      subscribe(id, options) {
        return consumer.subscriptions.create({channel: 'Game::MatchChannel', id: id}, options)
      },
    },
  }

  return cable
}
