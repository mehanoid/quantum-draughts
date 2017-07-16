import Vue from 'vue'
import Vuex from 'vuex'
import InitBoards from './initboards'
import serverApi from "../server_api"

Vue.use(Vuex)

export default function initStore() {
  return new Vuex.Store({
    state: {
      boards: (new InitBoards(gon.match.boards).getBoards()),
      selectedDraughtId: null
    },
    getters: {
      currentBoard(state){
        return state.boards[0]
      },
      currentCells(state, getters){
        return _.flattenDeep(getters.currentBoard)
      },
      cellById: (state, getters) => id =>{
        return getters.currentCells.find(c => c.draught && c.draught.id === id)
      },
      selectedCell(state, getters){
        return getters.cellById(state.selectedDraughtId)
      }
    },
    mutations: {
      selectDraught(state, draught){
        state.selectedDraughtId = draught.id
      },
      move(state, {from, to}){
        [to.draught, from.draught] = [from.draught, to.draught]
        state.selectedDraughtId = null
      }
    },
    actions: {
      async move({commit, getters}, to) {
        if (!getters.selectedCell || !to.playable) {
          return
        }
        const from = getters.selectedCell
        await serverApi.move(gon.match.id, {from, to})
        commit('move', {from, to})
      }
    }
  })
}
