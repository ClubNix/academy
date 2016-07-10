import AJAX from "web/static/js/lib/ajax.js";
import categorize from "web/static/js/lib/page-categorization.js";
import Animations from "web/static/js/lib/animations.js";

import { SearchWatcher, Searcher } from "web/static/js/front-search.js";

function buildState(uri) {
	return {
		uri: uri,
		category: categorize(uri)
	}
}

function changePage(oldState, newState) {
	Animations.prepareAnimateOut(document, oldState.category);
	Animations.animateOut(document, oldState.category)
		.then(function() {
			return AJAX.html(newState.uri);
		})
		.then(function(doc) {
			Animations.prepareAnimateIn(doc, newState.category);
			document.querySelector("main").innerHTML = doc.querySelector("main").innerHTML;
			// Dirty hack: let the browser have the time to relayout everything
			return new Promise(function(resolve, reject) {
				window.setTimeout((resolve) => resolve(), 50, resolve);
			});
		})
		.then(function() {
			Animations.animateIn(document, newState.category);
		})
		.then(function() {
			// Re-watch new links
			Watcher.watch();
		
			if(oldState.category == "user-index") {
				Searcher.clean();
			}

			if(newState.category == "user-index") {
				SearchWatcher.watch();
			}
		});
}

function goto(uri) {
	let oldState = history.state;
	let newState = buildState(uri);
	history.pushState(newState, document.title, newState.uri);
	changePage(oldState, newState);
	window.currentState = newState;
}

export var Watcher = {
	init: function() {
		window.currentState = buildState(window.location.pathname);
		history.replaceState(
			window.currentState,
			document.title,
			window.location.pathname);

		window.addEventListener("popstate", function(e) {
			if(e.state == null) {
				return;
			}

			changePage(window.currentState, e.state);
			window.currentState = e.state;
		});

		Watcher.watch();
	},

	watch: function() {
		for(let link of document.querySelectorAll(".member-card > a")) {
			link.addEventListener("click", function(e) {
				e.preventDefault();
				goto(link.getAttribute("href"));
			});
		}
	}
}
