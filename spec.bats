#!/usr/bin/env bats

setup() {
    rm -rf fixture

    mkdir fixture
    cd fixture
    git init

    cp ../commit-msg.js .git/hooks/commit-msg
}

createCommitFile() {
    echo Hello > file.txt
    git add file.txt
    git commit -m "$1"
}

@test "doesn't add prefix on master" {
    createCommitFile "Add file"

    [ "$(git log --format=%B)" == "Add file" ]
}

@test "adds prefix on branch named with ticket number prefix" {
    git checkout -b MYPROJ-123-new-feature

    createCommitFile "Add file"

    [ "$(git log --format=%B)" == "MYPROJ-123 Add file" ]
}

@test "doesn't add a prefix if one is already given" {
    git checkout -b MYPROJ-123-new-feature

    createCommitFile "MYPROJ-123 Add file"

    [ "$(git log --format=%B)" == "MYPROJ-123 Add file" ]
}

@test "respects UTF-8 characters in message" {
    git checkout -b MYPROJ-123-new-feature

    createCommitFile "Copyright ©"

    [ "$(git log --format=%B)" == "MYPROJ-123 Copyright ©" ]
}

@test "allows Git itself to reject empty commit message" {
    git checkout -b MYPROJ-123-new-feature

    run createCommitFile ""

    [ "$status" -eq 1 ]
    [ "$output" = "Aborting commit due to empty commit message." ]
}

@test "doesn't mess up multi-line commit messages when prefixing" {
    git checkout -b MYPROJ-123-new-feature

    createCommitFile $'One\nTwo\n\nThree'

    [ "$(git log --format=%B)" == $'MYPROJ-123 One\nTwo\n\nThree' ]
}

@test "prefixes even if another prefix is found later in the given message" {
    git checkout -b MYPROJ-123-new-feature

    createCommitFile "This enhances feature MYPROJ-100"

    [ "$(git log --format=%B)" == "MYPROJ-123 This enhances feature MYPROJ-100" ]
}
