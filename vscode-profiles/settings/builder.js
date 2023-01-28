#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const filenameToJSON = (filename) => {
  const filePath = path.join(__dirname, filename);
  const fileString = fs.readFileSync(filePath, "utf8");
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
  // const vim = filenameToJSON("vim.json");

  const profileSettingsName = parseArgs(process.argv);
  const profileSettings = profileSettingsName
    ? filenameToJSON(profileSettingsName)
    : {};

  const settings = {
    ...base,
    // ...vim,
    ...profileSettings,
  };

  const settingsPrettyString = `${JSON.stringify(settings, null, '\t')}\n`;
  const settingsPath = path.join(__dirname, "../common/data/User/settings.json");

  fs.writeFileSync(settingsPath, settingsPrettyString);

  // yes | cp "$HOME/.config/vscode-profiles/settings/settings.json" "$HOME/.config/vscode-profiles/common/data/User/settings.json" 
} catch (err) {
  console.error(err);
}
