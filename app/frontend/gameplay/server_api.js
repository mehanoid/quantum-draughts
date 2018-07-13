import axios from 'axios'
import cellsUtils from './utils/cell'

export default {
  matchPossibleMoves(matchId, from) {
    return axios.get(`/matches/${matchId}/possible_moves`, {
      params: {from: cellsUtils.name(from)}
    })
  },

  matchMove(matchId, moves) {
    return axios.post(`/matches/${matchId}/move`, {
      moves
    })
  }
}
