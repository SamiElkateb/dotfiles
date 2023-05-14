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
  const terminal = filenameToJSON("terminal.json");

  const tasks = [
    ...base,
    ...terminal
    // ...profileSettings,
  ];
  const taskObject = {
    "version": "2.0.0",
    "tasks": tasks
  }

  const tasksPrettyString = `${JSON.stringify(taskObject, null, '\t')}\n`;
  const tasksPath = path.join(__dirname, "../common/data/User/tasks.json");
  fs.writeFileSync(tasksPath, tasksPrettyString);
} catch (err) {
  console.error(err);
}
