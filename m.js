var ws = {
	send: function (m) {
		ws.onmessage({data: JSON.stringify({nick: "me", msg: m})});
	}
}
