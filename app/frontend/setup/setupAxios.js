import axios from 'axios'
const csrfToken = document.querySelector("meta[name=csrf-token]").content
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken
axios.defaults.headers.common['Accept'] = 'application/json'
