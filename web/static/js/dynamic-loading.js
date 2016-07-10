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

function copyFlashes(oldDoc, newDoc) {
	newDoc.querySelector(".alert.alert-error").innerText = oldDoc.querySelector(".alert.alert-error").innerText;
	newDoc.querySelector(".alert.alert-warn").innerText  = oldDoc.querySelector(".alert.alert-warn").innerText;
	newDoc.querySelector(".alert.alert-info").innerText  = oldDoc.querySelector(".alert.alert-info").innerText;
}

function changePage(oldState, newState) {
	Animations.prepareAnimateOut(document, oldState.category);

	Animations.hideFlashes(document)
		.then(function() {
			for(let flashEl of document.querySelectorAll(".alert")) {
				flashEl.innerText = "";
			}
		});

	Animations.animateOut(document, oldState.category)
		.then(function() {
			return AJAX.html(newState.uri);
		})
		.then(function(doc) {
			Animations.prepareAnimateIn(doc, newState.category);
			document.querySelector("main").innerHTML = doc.querySelector("main").innerHTML;

			copyFlashes(doc, document);
			Animations.showFlashes(document);

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

			if(document.querySelector(".input > input")) {
				require("./forms").Watcher.watch();
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

function addLoadingListener(link) {
	link.addEventListener("click", function(e) {
		e.preventDefault();
		goto(link.getAttribute("href"));
	});
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

		Watcher.staticWatch();
		Watcher.watch();
	},

	staticWatch: function() {
		addLoadingListener(document.querySelector("header[role='banner'] > h1 > a"));
		for(let link of document.querySelectorAll("nav[role='navigation'] a:not([href='/logout'])")) {
			addLoadingListener(link);
		}
	},

	watch: function() {
		for(let link of document.querySelectorAll(".member-card > a")) {
			addLoadingListener(link);
		}
	}
}
