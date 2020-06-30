# execute-all-scripts.sh

Will traverse through all the folders in sorted order starting with the lowest number, and execute all scripts within each folder with the extension `.sh`. Executable programs will not be executed directly and should be wrapped with a `.sh` file to start it.

This script should be run with a privileges account.

The scripts executed by `execute-all-scripts.sh` should only take 1 argument which is the directory of where the script is located. This is usually given in as a value in the `execute-all-scripts.sh` script.
