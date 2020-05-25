#!/usr/bin/env bats

# Change these configurations to match your hardware
EXPECTED_CPU_MANUFACTURER="AMD"
EXPECTED_GPU_MANUFACTURER="NVIDIA"
EXPECTED_OS="LINUX"

EXPECTED_CPU_TEMPERATURE_UNIT="°C"

main() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout
}

testCpuTempUnitsC() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout --cpu_temp C
}


# Test that the correct CPU brand is displayed by default
@test 'Test CPU brand' {
	run main

	lineToTest=${lines[14]}
	# Check if the manufacturer name appears in the CPU line from the output
	if [[ $lineToTest == *"${EXPECTED_CPU_MANUFACTURER}"* ]]; then
		echo "${lineToTest}" >&3
		echo "# CPU brand correctly displayed" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test that the correct GPU brand is displayed by default
@test 'Test GPU brand' {
	run main

	lineToTest=${lines[15]}
	# Check if the manufacturer name appears in the GPU line from the output
	if [[ $lineToTest == *"${EXPECTED_GPU_MANUFACTURER}"* ]]; then
		echo "# GPU brand correctly displayed" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test the cpu_temp flag for linux only
@test 'Test CPU temp units' {
	run testCpuTempUnitsC
	if [[$EXPECTED_OS != "LINUX"]]; then
		echo "# Skipping cpu temp test for non-linux OS."
		skip
	fi
	lineToTest=${lines[14]}
	# Check if the correct temperature units name appear in the
	if [[ $lineToTest == *"${EXPECTED_CPU_TEMPERATURE_UNIT}"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "#  CPU Temp displayed with correct units" >&3
	fi
	[ "${status}" -eq 0 ]
}


# Possible commands to test passing to Neofetch
# --cpu_brand on/off
# --cpu_temp C/F/off
# --gpu_brand on/off
# These are found around line 4677 in neofetch
# Still need to work on output checking/display
# Or copy over some of the code and test that in isolation

# Show memory pecentage in output.
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --memory_percent


# Run with: bats test1.bats
