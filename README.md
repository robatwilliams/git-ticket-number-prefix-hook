# Git commit message ticket number prefix hook
Automatically prefixes commit messages with ticket number from the branch name.

The current regular expression suits the JIRA style of ticket number: `ABC-123`. Commits made to a branch whose name starts with that pattern will have their message prefixed.

Review the unit tests to learn about other features and behaviour.

## Shell and JavaScript variants
JavaScript: easier for me to write, and hopefully easier for you to modify should you need to.

Shell (Bash): doesn't need Node.js, and ~10% faster.

## Installation
Copy `commit-msg` from `hooks/<variant>` to the `.git/hooks` folder in your repository clone folder.

## Tests
The hook is tested in a fixture Git repository. Tests are implemented and run using the [BATS](https://github.com/bats-core/bats-core/) framework; each one is a small shell script.

```bash
# Install BATS
git clone https://github.com/bats-core/bats-core.git

# Run tests
./test.sh
```
