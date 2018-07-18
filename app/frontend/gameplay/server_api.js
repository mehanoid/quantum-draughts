import axios from 'axios'

export default {
  matchMove(matchId, moves) {
    return axios.post(`/matches/${matchId}/move`, {
      moves
    })
  }
}
