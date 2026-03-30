Create a new task folder using the task ID provided as an argument (e.g., HQD-9999).

Steps:

1. Read all template files from ~/.claude/_templates/specs
2. Create directory .specs/$ARGUMENTS/ in the current project
3. Copy each template file into .specs/$ARGUMENTS/, replacing every occurrence of `<change-id>` with $ARGUMENTS
4. Update the symlink .specs/current to point to .specs/$ARGUMENTS/
5. Rename the current session to $ARGUMENTS using /rename
6. Confirm all files were created and show the directory structure.
