"use strict";
let express = require("express");
let app = express();
let ws = require("express-ws")(app);

let nicknames = [];
app.ws("/", function (s, req) {
	s.on("connect", function (e) {
		nicknames[s._socket._handle.fd] = null;
	});
	s.on("message", function (msg) {
		let id = s._socket._handle.fd;
		let nick = nicknames[id] ? nicknames[id] : id;
		if (msg.startsWith("/nick ")) {
			let nw = msg.slice(6).trim();
			if (nw=="" || nw=="Server")
				return;
			msg = nick + " → " + nw;
			nicknames[id] = nw;
			nick = "Server"; //for the broadcast
		}
		console.log(nick+": "+msg);
		ws.getWss().clients.forEach(function (c) {
			c.send(JSON.stringify({nick: nick, msg: msg}));
		});
	});
});

app.use(express.static('public'));

let port = process.env.PORT || 8080;
console.log("Listening on port " + port + "...");
app.listen(port);
