#!/bin/bash



function excludes() {


	for i in ${$1//,/ };do
	
		SystemExclude=$(printf  "%s "  "$SystemExclude --exclude=$i/*")

	done

	return $SystemExclude

}