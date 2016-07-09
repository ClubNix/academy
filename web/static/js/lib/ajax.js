function base(uri, callback) {
	return new Promise(function(resolve, reject) {
		let request = new XMLHttpRequest();
		request.open('GET', uri, true);

		request.onload = function() {
			if (request.status >= 200 && request.status < 400) {
				resolve(callback(request.responseText));
			} else {
				reject("Error while fetching " + uri + " : " + request.status);
			}
		};

		request.onerror = function() {
			reject("Request error while fetching " + uri);
		};

		request.send();
	});
}

export default {

	base: base,

	json: function(uri) {
		return base(uri, function(response) {
			return JSON.parse(response);
		});
	},

	html: function(uri) {
		return base(uri, function(response) {
			let doc = document.implementation.createHTMLDocument();
			doc.documentElement.innerHTML = response;
			return doc;
		});
	}
}
