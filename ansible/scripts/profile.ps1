# This profile is managed by Ansible.
# It automatically imports the Atomic Red Team module and sets default parameter values.

# Explicitly import the module from its standard installation path
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force

# Set the default path to the atomics folder to avoid having to type it for every command
$PSDefaultParameterValues = @{"Invoke-AtomicTest:PathToAtomicsFolder"="C:\AtomicRedTeam\atomics"}
