import serverApi from 'utils/server_api'

export default {
  move(match_id, moves){
    return serverApi.fetch(`/matches/${match_id}/move`, {
      method: 'post',
      body: moves,
    })
  }
}
