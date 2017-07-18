const csrfToken = document.querySelector('meta[name="csrf-token"]').content

export default {
  async fetch(url, {body, ...options} = {}) {
    const response = await fetch(url, {
      ...options,
      body: body && JSON.stringify(body),
      headers: {
        ...options.headers,
        'X-CSRF-Token': csrfToken,
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
    if (response.status >= 200 && response.status < 300) {
      const json = await response.json()
      return {json, response}
    }
    else{
      throw new Error(response.statusText)
    }
  }
}
