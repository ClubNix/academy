function addFilledClass(element) {
	if(element.value == "") {
		element.classList.remove("filled");
	} else {
		element.classList.add("filled");
	}
}

function addFilledClassWrapper(event) {
	addFilledClass(event.target);
}

export var Watcher = {
	watch: function() {
		let inputElements = document.querySelectorAll(".input > input");
		for(let element of inputElements) {
			addFilledClass(element);
			element.addEventListener("blur", addFilledClassWrapper);
		}
	}
}
