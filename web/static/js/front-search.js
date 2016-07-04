class MemberCard {
	constructor(id, name) {
		this.id = id;
		this.name = name;
		this.htmlCard = document.getElementById("member-" + id);
		if(!this.htmlCard) {
			console.warn("Non-existent user bound: id = " + id);
		}
		this.addendum = this.htmlCard.querySelector(".addendum");
		this.skillLevels = window.users[id - 1].skill_levels;
	}

	highlightSkill(skillName) {
		let htmlCard = this.htmlCard;
		let self = this;
		return new Promise(function(resolve, reject) {
			for(let skillNameEl of htmlCard.querySelectorAll(".skill-name")) {
				if(skillNameEl.innerHTML == skillName) {
					skillNameEl.parentNode.classList.add("highlight");
					resolve();
					return;
				}
			}
			self.appendAddendum(skillName);
			resolve();
		});
	}

	clearHighlights() {
		let htmlCard = this.htmlCard;
		return new Promise(function(resolve, reject) {
			for(let row of htmlCard.querySelectorAll("tr")) {
				row.classList.remove("highlight");
			}
			resolve();
		});
	}

	dimSkills() {
		this.htmlCard.querySelector(".skills").classList.add("dimmed");
	}

	undimSkills() {
		this.htmlCard.querySelector(".skills").classList.remove("dimmed");
	}

	findSkillLevel(skillName) {
		for(let skillLevel of this.skillLevels) {
			if(skillLevel.skill.name == skillName) {
				return skillLevel;
			}
		}
		return false;
	}

	getAddendumTbody() {
		if(this.addendum.firstChild) {
			return this.addendum.firstChild;
		} else {
			return this.addendum.appendChild(document.createElement("tbody"));
		}
	}

	appendAddendum(skillName) {
		let skillLevel = this.findSkillLevel(skillName);

		let skillNameEl = document.createElement("td");
		skillNameEl.classList.add("skill-name");
		skillNameEl.classList.add("tooltip");
		skillNameEl.setAttribute("data-tooltip", skillLevel.skill.description);
		skillNameEl.innerHTML = skillName;

		let skillRatingEl = document.createElement("td");
		skillRatingEl.classList.add("rating");
		skillRatingEl.innerHTML = rating(skillLevel.level);

		let skillRowEl = document.createElement("tr");
		skillRowEl.classList.add("highlight");
		skillRowEl.appendChild(skillNameEl);
		skillRowEl.appendChild(skillRatingEl);

		this.getAddendumTbody().appendChild(skillRowEl);
	}

	clearAddendum() {
		if(this.addendum.firstChild) {
			this.addendum.removeChild(this.addendum.firstChild);
		}
	}

}

function rating(level) {
	return "★".repeat(level) + "☆".repeat(5 - level);
}

function fetchUsers() {
	return new Promise(function(resolve, reject) {
		if(window.users) {
			resolve(window.users);
			return;
		}

		let request = new XMLHttpRequest();
		request.open('GET', '/api/users', true);

		request.onload = function() {
			if (request.status >= 200 && request.status < 400) {
				window.users = JSON.parse(request.responseText);
				resolve(window.users);
			} else {
				reject("Error while fetching users: " + request.status);
			}
		};

		request.onerror = function() {
			reject("Request error while fetching users.");
		};

		request.send();
	});
}

function buildSearchTrees(users) {
	window.skills = {}
	window.usernames = {}
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

function buildMemberCards() {
	window.cards = [];
	for(let user of window.users) {
		window.cards.push(new MemberCard(user.id, user.name));
	}
}

function clearAllHighlights() {
	for(let card of window.cards) {
		card.clearHighlights();
	}
}

function dimAllSkills() {
	for(let card of window.cards) {
		card.dimSkills();
	}
}

function undimAllSkills() {
	for(let card of window.cards) {
		card.undimSkills();
	}
}

function clearAllAddenda() {
	for(let card of window.cards) {
		card.clearAddendum();
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
					buildSearchTrees(users);
				})
				.then(function() {
					console.log("Building member cards objects.");
					window.searchTreesBuilt = true;
					buildMemberCards();
				})
				.then(function() {
					console.log("Done.");
					Searcher.search();
				});
		}
	},

	search: function() {
		let query = document.getElementById("search-bar").value.toLowerCase();
		if(window.searchTreesBuilt && !empty(query)) {
			console.log("Searching for: " + query);
			clearAllHighlights();
			dimAllSkills();
			clearAllAddenda();
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
		clearAllHighlights();
		undimAllSkills();
		clearAllAddenda();
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
