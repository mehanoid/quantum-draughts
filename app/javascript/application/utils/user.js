import i18n from '@application/i18n'

export default {
  displayingName(user) {
    return user.displaying_name || i18n.t('commons.anonymousPlayerName', {id: user.id})
  },
}
