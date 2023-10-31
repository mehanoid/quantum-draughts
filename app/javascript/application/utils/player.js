import i18n from '@application/i18n'

export default {
  displayingName(player) {
    return player.displaying_name || i18n.t('commons.anonymousPlayerName', {id: player.id})
  },
}
