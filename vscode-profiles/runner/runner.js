#!/usr/bin/env node
const fs = require("fs");
const path = require("path");
const { execFileSync, exec, execSync } = require("child_process");

// exec(`osascript -e 'display notification "STARTED" with title "VSCODE"'`);

const filenameToJSON = (filename) => {
  const filePath = path.join(__dirname, filename);
  const fileString = fs.readFileSync(filePath, "utf8");
  return JSON.parse(fileString);
};

const parseArgs = (argv) => {
  return argv.reduce((acc, curr) => {
    if (curr === ".") {
      return { ...acc, openFolder: true };
    }
    if (curr.match(/^-p=\w+(.json)?$/))
      return { ...acc, lang: curr.match(/^-p=(\w+)(.json)?$/)[1] + ".json" };
    if (curr.match(/^--profile=\w+(.json)?$/))
      return {
        ...acc,
        lang: curr.match(/^--profile=(\w+)(.json)?$/)[1] + ".json",
      };
    return acc;
  }, {});
};

try {
  // fs.rmdirSync(path.join(__dirname, "../common/data/User/workspaceStorage"), {recursive: true, force: true});
  const code =
    "/Applications/Visual\\ Studio\\ Code.app/Contents/Resources/app/bin/code";
  const args = parseArgs(process.argv);
  const cache = filenameToJSON("cache.json");
  if (args.lang) {
    cache.lang = args.lang;
    const cachePrettyString = `${JSON.stringify(cache, null, "\t")}\n`;
    const cachePath = path.join(__dirname, "./cache.json");
    fs.writeFileSync(cachePath, cachePrettyString);
  } else {
    args.lang = cache.lang;
  }

  const settingsBuilderPath = path.join(__dirname, "../settings/builder.js");
  execFileSync(settingsBuilderPath, [`--profile=${args.lang}`]);

  const projectBuilderPath = path.join(__dirname, "../projects/builder.js");
  execFileSync(projectBuilderPath, [`--profile=${args.lang}`]);

  const keybindingsBuilderPath = path.join(__dirname, "../keybindings/builder.js");
  execFileSync(keybindingsBuilderPath, [`--profile=${args.lang}`]);

  const tasksBuilderPath = path.join(__dirname, "../tasks/builder.js");
  execFileSync(tasksBuilderPath, [`--profile=${args.lang}`]);

  const extensionDisablerPath = path.join(
    __dirname,
    "../extensions/disabler.js"
  );
  const extensionsToDisable = JSON.parse(
    execFileSync(extensionDisablerPath, [`--profile=${args.lang}`]).toString()
  );

  const disabledExtensions = extensionsToDisable.reduce(
    (acc, curr) => acc + `--disable-extension ${curr} `,
    ""
  );
  const openFolder = args.openFolder ? "." : "";
  const command = `${code} -n --user-data-dir="$HOME/.config/vscode-profiles/common/data" --extensions-dir="$HOME/.config/vscode-profiles/common/extensions" ${disabledExtensions} ${openFolder}`;

  const commandPath = path.join(__dirname, "./command.sh");
  // const script = `#!/bin/bash\n${command}`;
  // fs.writeFileSync(commandPath, script);
  console.log(command);
  exec(command);
} catch (err) {
  console.error(err);
}
