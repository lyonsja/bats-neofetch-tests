#!/usr/bin/env bats

main() {
	bash "${BATS_TEST_DIRNAME}"/test
}


@test 'example test for neofetch' {
	run main
	[ "${status}" -eq 0 ]

}
