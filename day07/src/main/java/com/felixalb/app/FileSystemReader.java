package com.felixalb.app;

import java.util.ArrayList;

public class FileSystemReader {
  ArrayList<String[]> commands = new ArrayList<String[]>();
  ArrayList<String> workingDirectory = new ArrayList<String>();
  FileNode root = new FileNode("/", true);

  public FileSystemReader(String[] lines) {
    ArrayList<String> currentCommand = new ArrayList<String>();
    for (String line : lines) {
      if (line.startsWith("$") && currentCommand.size() > 0) {
        commands.add(currentCommand.toArray(new String[0]));
        currentCommand = new ArrayList<String>();
      }

      currentCommand.add(line);
    }
    if (currentCommand.size() > 0) {
      commands.add(currentCommand.toArray(new String[0]));
    }

    System.out.println("Commands: " + commands.size());

    for (String[] command : commands) {
      this.parseCommand(command);
    }
  }

  public void printState() {
    System.out.println("Working directory: " + this.workingDirectory);
    this.root.printNode("");
  }

  public FileNode getRoot() {
    return this.root;
  }

  private FileNode getNode(String path, Boolean create) {
    String[] pathParts = path.split("/");
    FileNode currentNode = root;
    for (String pathPart : pathParts) {
      if (pathPart.length() == 0) {
        continue;
      }
      ArrayList<FileNode> children = currentNode.getChildren();
      FileNode child = null;
      for (FileNode childCandidate : children) {
        if (childCandidate.getName().equals(pathPart)) {
          child = childCandidate;
          break;
        }
      }

      if (child == null) {
        if (create) {
          child = new FileNode(pathPart, false);
          currentNode.appendChild(child);
        } else {
          return null;
        }
      }
      currentNode = child;
    }
    return currentNode;
  }

  public ArrayList<String[]> getCommands() {
    return commands;
  }

  public void parseCommand(String[] command) {
    String[] commandParts = command[0].split(" ");
    String commandName = commandParts[1];
    // System.out.println("Command: " + commandName);

    if (commandName.equals("cd")) {
      String path = commandParts[2];
      switch (path) {
        case "/" :
          workingDirectory = new ArrayList<String>();
          break;
        case ".." :
          workingDirectory.remove(workingDirectory.size() - 1);
          break;
        default :
          workingDirectory.add(path);
          break;
      }
      // System.out.println("Working directory: /" + String.join("/", workingDirectory));
    } else if (commandName.equals("ls")) {
      FileNode dir = getNode(String.join("/", workingDirectory), false);
      if (dir == null) {
        System.out.println("ls: cannot access " + String.join("/", workingDirectory) + ": No such file or directory");
      } else {
        for (String line : command) {
          String[] lineParts = line.split(" ");
          if (lineParts[0].equals("$")) {
            continue;
          }
          if (lineParts[0].equals("dir")) {
            FileNode newDir = new FileNode(lineParts[1], true);
            dir.appendChild(newDir);
          } else {
            FileNode newFile = new FileNode(lineParts[1], false);
            newFile.setSize(Integer.parseInt(lineParts[0]));
            dir.appendChild(newFile);
          }
        }
      }
    } else {
      throw new RuntimeException("Unknown command: '" + commandName + "'");
    }
  }
}
