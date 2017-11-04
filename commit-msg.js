#!/usr/bin/env node
const child_process = require("child_process");
const fs = require("fs");

const prefixRegExp = /^([A-Z]+-[0-9]+).*/;

const messageFile = process.argv[2];
const originalMessage = fs.readFileSync(messageFile, { encoding: "UTF-8" });

if (originalMessage.length === 0) {
    process.exit(0);    // let Git reject it
}

const branchRegexMatch = prefixRegExp.exec(getBranchName());

if (!branchRegexMatch) {
    console.log("commit-msg: on non-prefixed branch; no action");
    process.exit(0);
}

if (prefixRegExp.test(originalMessage)) {
    console.log("commit-msg: message already prefixed; no action");
} else if (getMergeHead()) {
    console.log("commit-msg: merge commit; no action");
} else {
    const desiredPrefix = branchRegexMatch[1];
    console.log("commit-msg: prefix not found; prepending %s", desiredPrefix);

    fs.writeFileSync(messageFile, desiredPrefix + " " + originalMessage);
}

function getBranchName() {
    return child_process.execSync("git symbolic-ref --short -q HEAD", { encoding: "UTF-8" });
}

function getMergeHead() {
    try {
        return child_process.execSync("git rev-parse -q --verify MERGE_HEAD");
    } catch (e) {
        if (e.stdout.length + e.stderr.length > 0) {
            throw e;
        }
    }
}
