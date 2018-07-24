export default {
	cellByName(board, name) {
		return _.flattenDeep(board.rows).find(c => c.name === name)
	}
}
