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
  const extensionsData = filenameToJSON( "../common/extensions/extensions.json");
  const availableExtensionsIds = extensionsData.map(extensionData => (extensionData.identifier.id.toLowerCase()));


  const base = filenameToJSON("base.json");

  const extensionSettingsName = parseArgs(process.argv);
  const extensionSettings = extensionSettingsName
    ? filenameToJSON(extensionSettingsName)
    : [];

  const enabledExtensions = [
    ...base.map(item => item.toLowerCase()),
    ...extensionSettings.map(item => item.toLowerCase()),
  ];

  const extensionToDisable = availableExtensionsIds.filter((item) => !enabledExtensions.includes(item));
  console.log(JSON.stringify(extensionToDisable));
  // return JSON.stringify(extensionToDisable);
} catch (err) {
  console.error(err);
}
