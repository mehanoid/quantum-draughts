import serverApi from '@application/serverApi'

export default {
  async updateCurrentUser({commit}) {
    const {data: currentUser} = await serverApi.currentUserGet()
    commit('setCurrentUser', currentUser)
  },
}
