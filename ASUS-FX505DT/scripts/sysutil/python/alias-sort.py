# Specify the path to your .alias file
alias_file_path = "/home/aidan/.alias"

# Read the contents of the file
with open(alias_file_path, 'r') as file:
    lines = file.readlines()

# Extract aliases and sort them based on the second word
aliases = [line.strip() for line in lines if line.startswith('alias ')]
sorted_aliases = sorted(aliases, key=lambda alias: alias.split()[1])

# Write the sorted aliases back to the file
with open(alias_file_path, 'w') as file:
    for line in lines:
        if line.startswith('alias '):
            file.write(sorted_aliases.pop(0) + '\n')
        else:
            file.write(line)
