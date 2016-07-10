import AJAX from "web/static/js/lib/ajax.js"

function updateContent(uri) {
	AJAX.html(uri).then(function(doc) {
		document.querySelector("main").innerHTML = doc.querySelector("main").innerHTML;
	});
}

function goto(uri) {
	history.pushState({uri: uri}, document.title, uri);
	updateContent(uri);
}

export var Watcher = {
	watch: function() {
		history.replaceState({ uri: window.location.pathname }, document.title, window.location.pathname);

		window.addEventListener("popstate", function(e) {
			if(e.state == null) {
				return;
			}

			updateContent(e.state.uri);
		});

		for(let link of document.querySelectorAll(".member-card > a")) {
			link.addEventListener("click", function(e) {
				e.preventDefault();
				goto(link.getAttribute("href"));
			});
		}
	}
}
