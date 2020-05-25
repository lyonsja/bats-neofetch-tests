#!/usr/bin/env bats

# Run with: bats test1.bats
# bats-core needs to be installed for this to work.

# Change these configurations to match your hardware
EXPECTED_CPU_MANUFACTURER="AMD"
EXPECTED_GPU_MANUFACTURER="NVIDIA"
EXPECTED_OS="LINUX"

EXPECTED_CPU_TEMPERATURE_UNIT="°C"
# Valid values are: C, F, off
CPU_TEMPERATURE_FLAG="C"
EXPECTED_DISK_PATH="/deb/sdb2"

main() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout
}

testCpuTempUnitsC() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout --cpu_temp $CPU_TEMPERATURE_FLAG
}

testGpuManufOff() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout --gpu_brand off
}

testCpuManfOff() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout --cpu_brand off
}

testIncludeDisk() {
	bash "${BATS_TEST_DIRNAME}"/neofetch --stdout --disk_show $EXPECTED_DISK_PATH
}


# Test that the correct CPU brand is displayed by default
@test 'CPU brand correctly displayed' {
	run main

	lineToTest=${lines[14]}
	# Check if the manufacturer name appears in the CPU line from the output
	if [[ $lineToTest == *"${EXPECTED_CPU_MANUFACTURER}"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "# CPU brand correctly displayed" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test that the correct GPU brand is displayed by default
@test 'GPU brand correctly displayed' {
	run main

	lineToTest=${lines[15]}
	# Check if the manufacturer name appears in the GPU line from the output
	if [[ $lineToTest == *"${EXPECTED_GPU_MANUFACTURER}"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "# GPU brand correctly displayed" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test the cpu_temp flag for linux only
@test 'CPU should be displaying with correct temp units' {
	run testCpuTempUnitsC

	lineToTest=${lines[14]}
	if [$EXPECTED_OS != "LINUX"]; then
		skip "# Skipping cpu temp test for non-linux OS."
	fi
	# Check if the correct temperature units name appear in the
	if [[ $lineToTest == *"${EXPECTED_CPU_TEMPERATURE_UNIT}"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "#  CPU Temp displayed with correct units" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test disabling the cpu manufacturer
@test 'CPU brand should be left off' {
	run testCpuManfOff

	lineToTest=${lines[14]}
	# Check if the manufacturer name appears in the CPU line from the output
	if [[ $lineToTest != *"${EXPECTED_CPU_MANUFACTURER}"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "# CPU brand correctly left off" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test disabling the gpu manufacturer
@test 'GPU brand should be off' {
	run testGpuManufOff

	lineToTest=${lines[15]}
	# Check if the manufacturer name appears in the CPU line from the output
	if [[ $lineToTest != *"${EXPECTED_GPU_MANUFACTURER}"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "# GPU brand correctly left off" >&3
	fi
	[ "${status}" -eq 0 ]
}

# Test showing the disk line in the output
@test 'Specified disk should be included in the output' {
	run testIncludeDisk

	lineToTest=${lines[16]}
	# Check if the manufacturer name appears in the CPU line from the output
	if [[ $lineToTest == *"%"* ]]; then
		echo "# ${lineToTest}" >&3
		echo "# Disk correctly shown" >&3
		[ "${status}" -eq 0 ]
	fi
	[ "${status}" -eq 1 ]
}


# The relevant flag information is found
# around line 4677 in neofetch
