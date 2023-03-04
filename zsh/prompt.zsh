##      ##
# Prompt #
##      ##

# TODO: add git integration

prompt_setup() {
	local user="%F{124}%n%f"
	local host="%F{239}@%M%f"
	local cwd="%F{162}%~%f"
	local state="%F{white}%(!.#.>)%f"

	PROMPT="%B$user$host%b $cwd $state "
}

prompt_setup
