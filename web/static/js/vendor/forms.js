import "phoenix_html"

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

function watchForInputFilling() {
	let inputElements = document.querySelectorAll(".input > input");
	for(let element of inputElements) {
		addFilledClass(element);
		element.addEventListener("blur", addFilledClassWrapper);
	}
}

if (document.readyState != 'loading'){
	watchForInputFilling();
} else {
	document.addEventListener('DOMContentLoaded', watchForInputFilling);
}
