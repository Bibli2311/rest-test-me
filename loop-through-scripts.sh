#!/bin/bash

# List files and sort them
files=$(ls /sql-scripts | sort -V)

# Loop through each file and run a command
for file in $files; do
    # Replace 'your_command' with the command you want to run
    echo $file
    # run each sql script with sqlcmd
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "lololol7261()()" -C -i "/sql-scripts/$file"
done

