#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Make executable
chmod +x /usr/share/STMicroelectronics/STM32CubeProgrammer/bin/STM32CubeProgrammerLauncher
chmod +x /usr/share/STMicroelectronics/STM32CubeProgrammer/bin/STM32_Programmer.sh
chmod +x /usr/share/STMicroelectronics/STM32CubeProgrammer/bin/STM32_Programmer_CLI
chmod +x /usr/share/STMicroelectronics/STM32CubeProgrammer/bin/STM32CubeProgrammer
