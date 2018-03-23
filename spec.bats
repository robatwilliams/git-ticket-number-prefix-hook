#!/usr/bin/env bats

setup() {
    rm -rf fixture

    mkdir fixture
    cd fixture
    git init

    cp ../commit-msg .git/hooks/commit-msg
}

createCommitFile() {
    local filename=${2:-file.txt}

    echo Hello > $filename
    git add $filename
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

@test "doesn't add a prefix if correct one is already given" {
    git checkout -b MYPROJ-123-new-feature

    createCommitFile "MYPROJ-123 Add file"

    [ "$(git log --format=%B)" == "MYPROJ-123 Add file" ]
}

@test "aborts commit if incorrect prefix one is already given" {
    git checkout -b MYPROJ-123-new-feature

    run createCommitFile "MYPROJ-100 Add file"

    [ "$status" -eq 1 ]
    [ "$output" = "commit-msg: message prefix 'MYPROJ-100' does not match branch prefix 'MYPROJ-123'" ]
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

@test "doesn't prefix merge commits" {
    git checkout -b MYPROJ-123-new-feature
    createCommitFile "a"

    git checkout -b other
    createCommitFile "b" "anotherFile.txt"

    git checkout MYPROJ-123-new-feature
    git merge --no-ff other

    [ "$(git log -n 1 --format=%B)" ==  "Merge branch 'other' into MYPROJ-123-new-feature" ]
}

@test "doesn't prefix fixup commits" {
    git checkout -b MYPROJ-123-new-feature
    createCommitFile "message"

    echo HelloAgain > file.txt
    git add file.txt
    git commit --fixup HEAD

    [ "$(git log -n 1 --format=%B)" == "fixup! MYPROJ-123 message" ]
}

@test "doesn't prefix squash commits" {
    git checkout -b MYPROJ-123-new-feature
    createCommitFile "message"

    echo HelloAgain > file.txt
    git add file.txt
    git commit --squash HEAD -m "body"

    [ "$(git log -n 1 --format=%s)" == "squash! MYPROJ-123 message" ]
    [ "$(git log -n 1 --format=%b)" == "body" ]
}
