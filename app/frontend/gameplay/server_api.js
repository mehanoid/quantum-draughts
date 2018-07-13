import axios from 'axios'
import cellsUtils from './utils/cell'

export default {
  matchPossibleMoves(matchId, from) {
    return axios.get(`/matches/${matchId}/possible_moves`, {
      params: {from: cellsUtils.name(from)}
    })
  },

  matchMove(matchId, {from, to}) {
    return axios.post(`/matches/${matchId}/move`, {
      moves: [
        cellsUtils.name(from),
        cellsUtils.name(to),
      ]
    })
  }
}
