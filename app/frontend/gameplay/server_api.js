import serverApi from 'utils/server_api'

export default {
  move(match_id, {from, to}){
    return serverApi.fetch(`/matches/${match_id}/move`, {
      method: 'post',
      body: {
        moves: [
          `${from.column}${from.row}`,
          `${to.column}${to.row}`
        ]
      },
    })
  }
}
