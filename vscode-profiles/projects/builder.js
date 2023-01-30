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

  const profileProjectsName = parseArgs(process.argv);
  const profileProjects = profileProjectsName
    ? filenameToJSON(profileProjectsName)
    : {};

  const settings = [
    ...base,
    ...profileProjects,
  ];

  const projectsPrettyString = `${JSON.stringify(settings, null, '\t')}\n`;
  const projectsPath = path.join(__dirname, "../common/data/User/globalStorage/alefragnani.project-manager/projects.json");

  fs.writeFileSync(projectsPath, projectsPrettyString);
} catch (err) {
  console.error(err);
}
