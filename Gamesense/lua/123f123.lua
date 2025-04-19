exswitch = var_155_4.feature({
	var_155_5.angles:checkbox("Auto hide shots")
}, function(arg_164_0)
	return {
		allow = var_155_5.angles:multiselect("\f<p>Additional weapons", {
			"Pistols",
			"Desert Eagle"
		})
	}, true
end),