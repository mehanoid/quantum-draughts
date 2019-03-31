import axios from 'axios'

export default {
  matchCreate: (game_match) =>
    axios.post('/game/matches', {game_match}),
  matchMove: (matchId, moves) =>
    axios.post(`/game/matches/${matchId}/move`, {
      moves,
    }),
  matchJoin: (matchId) =>
    axios.post(`/game/matches/${matchId}/join`),
  matchGet: (id) =>
    axios.get(`/game/matches/${id}`),
  matchesGet: () =>
    axios.get('/game/matches'),
  matchTurnGet: (id) =>
    axios.get(`/game/match_turns/${id}`),
}
