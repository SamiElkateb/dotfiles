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
  const vimBase = openLocalFile("./vim/base.vim");

  const base = filenameToJSON("base.json");
  // const vim = filenameToJSON("vim.json");

  const profileName = parseArgs(process.argv);
  const profileSettings = profileName
    ? filenameToJSON(profileName)
    : {};

  const profileVim = profileName
    ? openLocalFile(`vim/ftplugin/${profileName.replace('.json', '.vim')}`)
    : '';

  const settings = {
    ...base,
    // ...vim,
    ...profileSettings,
  };

  const settingsPrettyString = `${JSON.stringify(settings, null, '\t')}\n`;
  const settingsPath = path.join(__dirname, "../common/data/User/settings.json");
  fs.writeFileSync(settingsPath, settingsPrettyString);

  const vimPath = path.join(__dirname, "./init.vim");
  const vimString = `${vimBase}\n${profileVim}`;
  fs.writeFileSync(vimPath, vimString);

  // yes | cp "$HOME/.config/vscode-profiles/settings/settings.json" "$HOME/.config/vscode-profiles/common/data/User/settings.json" 
} catch (err) {
  console.error(err);
}
