import axios from 'axios'

export default {
  matchMove(matchId, moves) {
    return axios.post(`/game/matches/${matchId}/move`, {
      moves
    })
  },
  matchTurnGet(id) {
    return axios.get(`/game/match_turns/${id}`)
  }
}
