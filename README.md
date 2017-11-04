# Git commit message ticket number prefix hook
Automatically prefixes commit messages with ticket number from the branch name.

The current regular expression suits the JIRA style of ticket number: `ABC-123`. Commits made to a branch whose name starts with that pattern will have their message prefixed.

Review the unit tests to learn about other features and behaviour.

## Requires Node.js
It's implemented in JavaScript, not shell script.

This made it easier for me to write, and will hopefully also make it easier for you to modify should you need to.

## Installation
Copy `commit-msg.js` to the `.git/hooks` folder in your repository, and remove the file extension.

## Tests
The hook is tested in a fixture Git repository. Tests are implemented and run using the [BATS](https://github.com/bats-core/bats-core/) framework; each one is a small shell script.

```bash
# Install BATS
git clone https://github.com/bats-core/bats-core.git

# Run tests
./bats-core/libexec/bats spec.bats
```
