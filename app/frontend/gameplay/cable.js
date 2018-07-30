import matchChannel from './channels/matchChannel'

export default function ({store}) {
	if (process.env.NODE_ENV !== 'production') {
		ActionCable.startDebugging()
	}

	let consumer = ActionCable.createConsumer()
	const cable = {
		...consumer,
		consumer,
		store,
		channels: {}
	}

	cable.channels = {
		match: matchChannel(cable)
	}

	return cable
}
