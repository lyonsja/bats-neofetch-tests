#!/usr/bin/env bats

main() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout
}


@test 'example test for neofetch' {
	run main
	echo "# ${lines[14]}" >&3
	[ "${status}" -eq 0 ]
}


# Possible commands to test passing to Neofetch
# --cpu_brand on/off
# --cpu_temp C/F/off
# --gpu_brand on/off
# These are found around line 4677 in neofetch
# Still need to work on output checking/display
# Or copy over some of the code and test that in isolation
