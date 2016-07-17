import MemberCard, * as Cards from "web/static/js/lib/member-cards.js"
import AJAX from "web/static/js/lib/ajax.js"

function fetchUsers() {
	return AJAX.json("/api/users/");
}

function buildSearchTrees(users) {
	let skills = {};
	for(let user of users) {
		for(let skillLevel of user.skill_levels) {
			let skillName = skillLevel.skill.name;

			if(skills[skillName]) {
				skills[skillName].push(user.id);
			} else {
				skills[skillName] = [user.id];
			}

		}
	}
	return skills;
}

function match(base, query) {
	return base.indexOf(query) !== -1;
}

function empty(string) {
	return !/\S/.test(string);
}

export var Searcher = {
	init: function(elId) {
		if(!window.searchTreesBuilt) {
			console.log("Fetching users.");
			fetchUsers()
				.then(function(apiUsers) {
					let users = [];
					for(let user of apiUsers) {
						users[user.id] = user;
					}

					console.log("Building search trees");
					let skills = buildSearchTrees(apiUsers);
					window.searchTreesBuilt = true;

					console.log("Building member cards objects.");
					let cards = Cards.buildAll(users);
					console.log("Done.");

					Searcher.search(cards, skills);
					SearchWatcher.watchInput(elId, cards, skills);
				});
		}
	},

	search: function(cards, skills) {
		let query = document.getElementById("search-bar").value.toLowerCase();
		if(window.searchTreesBuilt && !empty(query)) {

			console.log("Searching for: " + query);
			Searcher.partialClear(cards);
			Cards.dimAllSkills(cards);

			for(let skillName in skills) {
				if(match(skillName.toLowerCase(), query)) {
					for(let userId of skills[skillName]) {
						cards[userId].highlightSkill(skillName);
					}
				}
			}

		} else if(empty(query)) {
			Searcher.clear(cards);
		}
	},

	partialClear: function(cards) {
		Cards.clearAllHighlights(cards);
		Cards.clearAllAddenda(cards);
	},

	clear: function(cards) {
		console.log("Clearing search.");
		Searcher.partialClear(cards);
		Cards.undimAllSkills(cards);
	}
}

export var SearchWatcher = {
	watchFocus: function(elId) {
		document.getElementById(elId).addEventListener("focus", function() {
			Searcher.init(elId);
		});
	},

	watchInput: function(elId, cards, skills) {
		document.getElementById(elId).addEventListener("input", function() {
			Searcher.search(cards, skills);
		});
	}
}

export var setup = function(config) {
	SearchWatcher.watchFocus(config["search-bar-id"]);
}
