const WHITE_IDS = _.range(1, 13)
const BLACK_IDS = _.range(13, 25)

const allIds = (color) =>
  color === 'white' ? WHITE_IDS : BLACK_IDS

export default {
  getters: {
    draughtsAll(state, getters) {
      return _(getters.multiCells)
        .map(c => c.draught)
        .compact()
        .groupBy(d => d.id)
        .entries()
        .map(([_id, group]) => {
          const weight = _.sumBy(group, d => d.weight)
          const probability = Math.round(100 * weight / getters.boardsTotalWeight)

          return {
            ...group[0],
            weight,
            probability,
          }
        }).value()
    },

    draughtsBeaten: (state, getters) => (color) => {
      const colorDraughts = getters.draughtsAll.filter(d => d.color === color)
      const probableBeatenDraugts = colorDraughts
        .filter(d => d.probability < 100)
        .map(d => ({
          ...d,
          probability: 100 - d.probability,
          king: false,
        }))

      const reallyBeatenIds = _.difference(allIds(color), colorDraughts.map(d => d.id))
      const reallyBeatenDraughts = reallyBeatenIds.map(id => ({
        id,
        color,
        probability: 100,
      }))
      return _.sortBy([...probableBeatenDraugts, ...reallyBeatenDraughts], d => -d.probability)
    },

    draughtsBeatenWhite(state, getters) {
      return getters.draughtsBeaten('white')
    },

    draughtsBeatenBlack(state, getters) {
      return getters.draughtsBeaten('black')
    },
  },
}
