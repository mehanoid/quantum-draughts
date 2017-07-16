const csrfToken = document.querySelector('meta[name="csrf-token"]').content

export default {
  fetch(url, {body, ...options} = {}){
    return fetch(url, {
      ...options,
      body: body && JSON.stringify(body),
      headers: {
        ...options.headers,
        'X-CSRF-Token': csrfToken,
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
  }
}
