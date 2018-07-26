import axios from 'axios'

export default {
  matchMove(matchId, moves) {
    return axios.post(`/game/matches/${matchId}/move`, {
      moves
    })
  }
}
