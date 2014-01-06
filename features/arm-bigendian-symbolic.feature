Feature: Check if symbolic execution creates the right constraints for big endian values

    Background:
        Given current test directory at "tests/arm-bigendian"
        Given S2E config file named "symbolic.armeb.c.elf-config.lua"
        Given ARM firmware named "symbolic.armeb.c.elf"
        When S2E test is run for architecture "armeb"

    Scenario: Both branches are executed and the symbolic value is correctly converted to a concrete
        Then the file "s2e-last/debug.txt" should contain "OK: sample == 42"
		And the file "s2e-last/debug.txt" should contain "OK: sample != 42"

    Scenario: Testcase generator is converting bytes to int values correctly
        Then the file "s2e-last/debug.txt" should contain:
        """
        v0_symbolic_test_0: 00 00 00 00, (int32_t) 0, (string) "...."
        """
        And the file "s2e-last/debug.txt" should contain:
        """
        v0_symbolic_test_0: 00 00 00 2a, (int32_t) 42, (string) "...*"
        """
