function addOutClass(doc, elSelector) {
	doc.querySelector(elSelector).classList.add("out");
}

function addOutClasses(doc, elSelector) {
	for(let el of doc.querySelectorAll(elSelector)) {
		el.classList.add("out");
	}
}

function removeOutClass(doc, elSelector) {
	doc.querySelector(elSelector).classList.remove("out");
}

function removeOutClasses(doc, elSelector) {
	for(let el of doc.querySelectorAll(elSelector)) {
		el.classList.remove("out");
	}
}

var animatableComponents = {
	"user-index": {
		single: [".member-card-grid", ".search"],
		multiple: [],
		timeout: 1000
	},
	"user-page": {
		single: [".member-card"],
		multiple: [],
		timeout: 280
	}
}

export default {

	prepareAnimateIn: function(doc, category) {
		console.log("Preparing in of " + category);

		if(animatableComponents[category]) {
			let singleComponents   = animatableComponents[category].single;
			let multipleComponents = animatableComponents[category].multiple;

			for(let component of singleComponents) {
				addOutClass(doc, component);
			}

			for(let component of multipleComponents) {
				addOutClasses(doc, component);
			}
		}
	},

	animateIn: function(doc, category) {
		console.log("Animating in of " + category);
		return new Promise(function(resolve, reject) {
			if(animatableComponents[category]) {
				let singleComponents   = animatableComponents[category].single;
				let multipleComponents = animatableComponents[category].multiple;
				let timeout            = animatableComponents[category].timeout;

				for(let component of singleComponents) {
					removeOutClass(doc, component);
				}

				for(let component of multipleComponents) {
					removeOutClasses(doc, component);
				}

				window.setTimeout((resolve) => resolve(), timeout, resolve);
			} else {
				resolve();
			}
		});
	},

	prepareAnimateOut: function(doc, category) {
		console.log("Preparing out of " + category);

		if(animatableComponents[category]) {
			let singleComponents   = animatableComponents[category].single;
			let multipleComponents = animatableComponents[category].multiple;

			for(let component of singleComponents) {
				removeOutClass(doc, component);
			}

			for(let component of multipleComponents) {
				removeOutClasses(doc, component);
			}
		}
	},

	animateOut: function(doc, category) {
		console.log("Animating out of " + category);
		return new Promise(function(resolve, reject) {
			if(animatableComponents[category]) {
				let singleComponents   = animatableComponents[category].single;
				let multipleComponents = animatableComponents[category].multiple;
				let timeout            = animatableComponents[category].timeout;

				for(let component of singleComponents) {
					addOutClass(doc, component);
				}

				for(let component of multipleComponents) {
					addOutClasses(doc, component);
				}

				window.setTimeout((resolve) => resolve(), timeout, resolve);
			} else {
				resolve();
			}
		});
	},

	hideFlashes: function(doc) {
		console.log("Hiding flashes");
		return new Promise(function(resolve, reject) {
			addOutClasses(doc, ".alert");
			window.setTimeout((resolve) => resolve(), 280, resolve);
		});
	},

	showFlashes: function(doc) {
		console.log("Showing flashes");
		return new Promise(function(resolve, reject) {
			removeOutClasses(doc, ".alert");
			window.setTimeout((resolve) => resolve(), 280, resolve);
		});
	}

}
