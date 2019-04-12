import delay from '@application/utils/delay'

export default {
  namespaced: true,

  state() {
    return {
      queue: [],
      snackbar: null,
    }
  },

  getters: {
    visible(state) {
      return !!state.snackbar
    },
  },

  mutations: {
    push(state, snackbar) {
      if (!state.snackbar && !state.queue.length) {
        state.snackbar = snackbar
      }
      else {
        state.queue.push({
          ...snackbar,
          timeout: 5000,
        })
      }
    },

    setSnackbar(state, value) {
      state.snackbar = value
    },

    showNext(state) {
      state.snackbar = state.queue.shift()
    },
  },

  actions: {
    async setVisible({state, commit}, value) {
      // Если значение false - прячем текущее сообщение, достаём следущее из очереди
      // если true - ничего не делаем, она и так видима, либо, если очередь пуска,
      // показывать всё равно нечего
      if (!value) {
        commit('setSnackbar', null)
        if (state.queue.length) {
          await delay(1000)
          commit('showNext')
        }
      }
    },
  },
}
