import MemberCard, * as Cards from "web/static/js/lib/member-cards.js"
import AJAX from "web/static/js/lib/ajax.js"

function fetchUsers() {
	return AJAX.json("/api/users/");
}

function buildSearchTrees(users) {
	window.skills = {};
	window.usernames = {};
	for(let user of users) {
		window.usernames[user.name] = user.id;
		partialBuildSkillTree(user);
	}
}

function partialBuildSkillTree(user) {
	for(let skillLevel of user.skill_levels) {
		let skillName = skillLevel.skill.name;
		if(window.skills[skillName]) {
			window.skills[skillName].push(user.id);
		} else {
			window.skills[skillName] = [user.id];
		}
	}
}

function empty(string) {
	return !/\S/.test(string);
}

export var Searcher = {
	init: function() {
		if(!window.searchTreesBuilt) {
			console.log("Fetching users.");
			fetchUsers()
				.then(function(users) {
					console.log("Building search trees");
					window.users = users;
					buildSearchTrees(users);
					window.searchTreesBuilt = true;
					console.log("Building member cards objects.");
					Cards.buildAll(window.users);
					console.log("Done.");
					Searcher.search();
				});
		}
	},

	search: function() {
		let query = document.getElementById("search-bar").value.toLowerCase();
		if(window.searchTreesBuilt && !empty(query)) {
			console.log("Searching for: " + query);
			Cards.clearAllHighlights();
			Cards.dimAllSkills();
			Cards.clearAllAddenda();
			let matches = [];
			for(let skillName in window.skills) {
				if(skillName.toLowerCase().indexOf(query) != -1) {
					for(let userId of window.skills[skillName]) {
						window.cards[userId - 1].highlightSkill(skillName);
					}
				}
			}
		} else if(empty(query)) {
			Searcher.clearSearch();
		}
	},

	clearSearch: function() {
		console.log("Clearing search.");
		Cards.clearAllHighlights();
		Cards.undimAllSkills();
		Cards.clearAllAddenda();
	},

	clean: function() {
		console.log("Cleaning search.");
		if(window.searchTreesBuilt) {
			Searcher.clearSearch();
			window.searchTreesBuilt = false;
		}
	}
}

export var SearchWatcher = {
	watch: function() {
		document.getElementById("search-bar").addEventListener("input", function() {
			Searcher.search();
		});

		document.getElementById("search-bar").addEventListener("focus", function() {
			Searcher.init();
		});
	}
}
