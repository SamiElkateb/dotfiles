#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const openLocalFile = (localPath)=> {
  const filePath = path.join(__dirname, localPath);
  return fs.readFileSync(filePath, "utf8");
}

const filenameToJSON = (filename) => {
  const fileString = openLocalFile(filename);
  return JSON.parse(fileString);
};

const parseArgs = (argv) => {
  return argv.reduce((acc, curr) => {
    if (acc) return acc;
    if (curr.match(/^-p=\w+(.json)?$/))
      return curr.match(/^-p=(\w+)(.json)?$/)[1] + ".json";
    if (curr.match(/^--profile=\w+(.json)?$/))
      return curr.match(/^--profile=(\w+)(.json)?$/)[1] + ".json";
  }, undefined);
};

try {

  const base = filenameToJSON("base.json");
  const breadcrumbs = filenameToJSON("breadcrumbs.json");
  const commandPalette = filenameToJSON("commandPalette.json");
  const explorer = filenameToJSON("explorer.json");
  const navigation = filenameToJSON("navigation.json");
  const suggests = filenameToJSON("suggests.json");

  // const profileName = parseArgs(process.argv);
  // const profileSettings = profileName
  //   ? filenameToJSON(profileName)
  //   : {};

  const keybindings = [
    ...base,
    ...breadcrumbs,
    ...commandPalette,
    ...explorer,
    ...navigation,
    ...suggests
    // ...profileSettings,
  ];

  const keybindingsPrettyString = `${JSON.stringify(keybindings, null, '\t')}\n`;
  const keybindingsPath = path.join(__dirname, "../common/data/User/keybindings.json");
  fs.writeFileSync(keybindingsPath, keybindingsPrettyString);
} catch (err) {
  console.error(err);
}
