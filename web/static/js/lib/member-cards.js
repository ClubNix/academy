export default class MemberCard {
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

export function buildAll(users) {
	window.cards = [];
	for(let user of users) {
		window.cards.push(new MemberCard(user.id, user.name));
	}
}

export function clearAllHighlights() {
	for(let card of window.cards) {
		card.clearHighlights();
	}
}

export function dimAllSkills() {
	for(let card of window.cards) {
		card.dimSkills();
	}
}

export function undimAllSkills() {
	for(let card of window.cards) {
		card.undimSkills();
	}
}

export function clearAllAddenda() {
	for(let card of window.cards) {
		card.clearAddendum();
	}
}
