function checkURI(uri, candidate) {
	uri = uri.replace(/\/:\w+/gi, "/\\w+");

	if(uri.endsWith("/")) {
		uri += "?";
	} else {
		uri += "/?";
	}

	uri = "^" + uri + "$";
	return new RegExp(uri).test(candidate);
}

export default function(uri) {
	if(uri == "/" || checkURI("/users", uri)) {
		return "user-index";
	} else if(checkURI("/users/:user", uri)) {
		return "user-page";
	}
}
