const WHITE_IDS = _.range(1, 13)
const BLACK_IDS = _.range(13, 25)

const allIds = (color) =>
  color === 'white' ? WHITE_IDS : BLACK_IDS

export default {
  namespaced: true,

  getters: {
    all(state, getters, rootState, rootGetters) {
      return _(rootGetters.multiCells)
        .map(c => c.draught)
        .compact()
        .groupBy(d => d.id)
        .entries()
        .map(([_id, group]) => ({
          ...group[0],
          probability: _.sumBy(group, d => d.probability)
        })).value()
    },

    beaten: (state, getters) => (color) => {
      const colorDraughts = getters.all.filter(d => d.color === color)
      const probableBeatenDraugts = colorDraughts
        .filter(d => d.probability < 100)
        .map(d => ({
          ...d,
          probability: 100 - d.probability,
          king: false
        }))

      const reallyBeatenIds = _.difference(allIds(color), colorDraughts.map(d => d.id))
      const reallyBeatenDraughts = reallyBeatenIds.map(id => ({
        id,
        color,
        probability: 100
      }))
      return _.sortBy([...probableBeatenDraugts, ...reallyBeatenDraughts], d => -d.probability)
    },

    beatenWhite(state, getters) {
      return getters.beaten('white')
    },

    beatenBlack(state, getters) {
      return getters.beaten('black')
    }
  }
}
