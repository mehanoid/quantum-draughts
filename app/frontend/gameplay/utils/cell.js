export default {
	name: (cell) => `${cell.column}${cell.row}`,

	diff(cell1, cell2) {
		const cell1Coords = this.nameToCoords(cell1)
		const cell2Coords = this.nameToCoords(cell2)
		return [
			this.columnToNumber(cell2Coords.column) - this.columnToNumber(cell1Coords.column),
			cell2Coords.row - cell1Coords.row,
		]
	},

	nameToCoords(name) {
		return {
			column: name[0],
			row: +name[1]
		}
	},

	columnToNumber(column) {
		return column.charCodeAt(0) - 'A'.charCodeAt(0) + 1
	}
}
