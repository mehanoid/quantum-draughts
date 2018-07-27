import serverApi from '../../serverApi'

export default {
	namespaced: true,

	state() {
		return {
			matchTurns: [],
			selectedMatchTurnId: null
		}
	},
	getters: {
		selectedMatchTurn(state) {
			return state.matchTurns.find(t => t.id === state.selectedMatchTurnId)
		}
	},
	mutations: {
		addMatchTurn(state, turn) {
			state.matchTurns.push(turn)
		},

		setSelectedMatchTurn(state, id) {
			state.selectedMatchTurnId = id
		}
	},
	actions: {
		async selectMatchTurn({state, commit}, id) {
			if (!state.matchTurns.find(t => t.id === id)) {
				const result = await serverApi.matchTurnGet(id)
				commit('addMatchTurn', result.data)
			}
			commit('setSelectedMatchTurn', id)
		}
	}
}
