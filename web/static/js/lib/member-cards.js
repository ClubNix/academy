export default class MemberCard {
	constructor(id, name, skillLevels) {
		this.id = id;
		this.name = name;
		this.htmlCard = document.getElementById("member-" + id);
		if(!this.htmlCard) {
			console.warn("Non-existent user bound: id = " + id);
		}
		this.addendum = this.htmlCard.querySelector(".addendum");
		this.skillLevels = skillLevels;
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

export function buildAll(users) {
	let cards = [];
	for(let user of users) {
		// Not using a continuous array
		if(user) {
			cards[user.id] = new MemberCard(user.id, user.name, user.skill_levels);
		}
	}
	return cards;
}

export function clearAllHighlights(cards) {
	for(let card of cards) {
		if(card) {
			card.clearHighlights();
		}
	}
}

export function dimAllSkills(cards) {
	for(let card of cards) {
		if(card) {
			card.dimSkills();
		}
	}
}

export function undimAllSkills(cards) {
	for(let card of cards) {
		if(card) {
			card.undimSkills();
		}
	}
}

export function clearAllAddenda(cards) {
	for(let card of cards) {
		if(card) {
			card.clearAddendum();
		}
	}
}
