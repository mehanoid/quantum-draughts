import Vue from 'vue'
import VueI18n from 'vue-i18n'
import locales from './locales'

Vue.use(VueI18n)

let i18n

export default function initI18n () {
  i18n = new VueI18n({
    locale: 'ru',      // set locale
    fallbackLocale: 'ru',
    messages: locales, // set locale messages
  })

  return i18n
}

if (module.hot) {
  module.hot.accept(['./locales'], function () {
    const newLocales = require('./locales').default

    for (const [locale, messages] of Object.entries(newLocales)) {
      i18n.setLocaleMessage(locale, messages)
    }
  })
}
