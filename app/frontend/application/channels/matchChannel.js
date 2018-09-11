export default function ({consumer, store}) {
  return {
    subscribe(id) {
      return consumer.subscriptions.create({channel: 'Game::MatchChannel', id: id},
        {
          received(data) {
            store.commit('updateMatch', data)
          }
        })
    }
  }
}
