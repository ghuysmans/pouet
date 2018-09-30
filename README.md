# Simple Node.js chat server

There's currently nothing special going on about the Node.js server.

By default, the client-side JavaScript connects a WebSocket to the same server
that served the page using it. You can easily change this by editing
`public/real.js` since there's no such thing as Same-Origin Policies for WS.
