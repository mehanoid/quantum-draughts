import Vue from 'vue'
import { createConsumer, logger } from '@rails/actioncable/src'

export default function ({ store }) {
  Object.defineProperty(Vue.prototype, '$cable', {
    get: function () {
      return this.$root.$options.cable
    },
  })

  if (process.env.NODE_ENV !== 'production') {
    logger.enabled = true
  }

  const consumer = createConsumer()
  const cable = {
    consumer,
    store,
    channels: {},
  }

  cable.channels = {
    match: {
      subscribe(id, options) {
        return consumer.subscriptions.create({ channel: 'Game::MatchChannel', id: id }, options)
      },
    },
  }

  return cable
}
