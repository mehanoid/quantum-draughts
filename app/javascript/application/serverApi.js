import axios from 'axios'
import i18n from '@application/i18n'

let store = null

export default {
  init(options) {
    store = options.store

    axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector("meta[name=csrf-token]").content
    axios.defaults.headers.common['Accept'] = 'application/json'

    // Add a request interceptor
    axios.interceptors.request.use(function (config) {
      // Do something before request is sent
      return config
    }, function (error) {
      // Do something with request error
      store.commit('snackbars/push', {text: i18n.t('errors.connectionError')}, {root: true})
      return Promise.reject(error)
    })

    // Add a response interceptor
    axios.interceptors.response.use(function (response) {
      // Do something with response data
      return response
    }, function (error) {
      // Do something with response error

      const status = error.response && error.response.status

      if (status) {
        if (status === 500) {
          store.commit('snackbars/push', {text: i18n.t('errors.internalServerError'), color: 'error'})
        }
        else {
          store.commit('snackbars/push', {text: i18n.t('errors.requestError'), color: 'error'})
        }
      }
      else {
        store.commit('snackbars/push', {text: i18n.t('errors.connectionError'), color: 'error'})
      }

      return Promise.reject(error)
    })
  },

  currentPlayerGet: () =>
    axios.get('/game/current_player'),
  currentPlayerUpdate: (player) =>
    axios.patch('/game/current_player', {player}),
  matchCreate: (params) =>
    axios.post('/game/matches', params),
  matchMove: (matchId, moves) =>
    axios.post(`/game/matches/${matchId}/move`, {
      moves,
    }),
  matchJoin: (matchId) =>
    axios.post(`/game/matches/${matchId}/join`),
  matchGet: (id) =>
    axios.get(`/game/matches/${id}.json`),
  matchesGet: () =>
    axios.get('/game/matches.json'),
  matchTurnGet: (id) =>
    axios.get(`/game/match_turns/${id}`),
}
