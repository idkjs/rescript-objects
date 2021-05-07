require('isomorphic-fetch');

const fetchJson = url => fetch(url).then(response => response.json());

module.exports = { fetchJson };