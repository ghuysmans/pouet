function date() {
	return new Date().toTimeString().split(" ")[0];
}

function play(s) {
	if (document.getElementById("mute").checked)
		return;
	var a = document.getElementById("a");
	a.pause();
	a.src = s + ".mp3";
	a.play();
}

function append(...cells) {
	var tr = document.createElement("tr");
	for (var i=0; i<cells.length; i++) {
		var td = document.createElement("td");
		td.appendChild(document.createTextNode(cells[i]));
		tr.appendChild(td);
	}
	var table = document.getElementById("log");
	table.insertBefore(tr, table.firstChild);
}

var ws = new WebSocket("ws://"+location.host);

ws.onmessage = function (x) {
	var o = JSON.parse(x.data);
	append(o.nick, date(), o.msg);
	if (o.msg.startsWith("/sound "))
		play(o.msg.slice(7));
};

ws.onopen = function (e) {
	ws.send("hey!");
};

ws.onclose = ws.onerror = function (e) {
	location.reload();
}

function send() {
	var f = document.getElementById("msg");
	if (f.value.startsWith("/c")) {
		var table = document.getElementById("log");
		while (table.lastChild)
			table.removeChild(table.lastChild);
	}
	else
		ws.send(f.value);
	f.value = "";
	return false;
}

function sound(s) {
	if (document.getElementById("local").checked)
		play(s);
	else
		ws.send("/sound " + s);
}

function setNick(n) {
	ws.send("/nick " + document.getElementById("nick").value);
	document.getElementById("msg").focus();
	return false;
}
