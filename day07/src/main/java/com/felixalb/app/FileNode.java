package com.felixalb.app;

import java.util.ArrayList;

class FileNode {
  private String name;
  private Integer size;
  private Boolean isDirectory;
  private ArrayList<FileNode> children = new ArrayList<FileNode>();

  public FileNode(String name, Boolean isDirectory) {
    this.name = name;
    this.children = new ArrayList<FileNode>();
    this.isDirectory = isDirectory;
  }

  public Integer getSize() {
    if (this.isDirectory) {
      Integer size = 0;
      for (FileNode child : this.children) {
        size += child.getSize();
      }
      return size;
    } else {
      return this.size;
    }
  }

  public void setSize(Integer size) {
    if (this.isDirectory) {
      throw new RuntimeException("Cannot set size of directory");
    }
    this.size = size;
  }

  public String getName() {
    return name;
  }

  public ArrayList<FileNode> getChildren() {
    if (!this.isDirectory) {
      throw new RuntimeException("Cannot get children of file");
    }
    return this.children;
  }

  public void appendChild(FileNode child) {
    this.children.add(child);
  }

  public void printNode(String prefix) {
    System.out.println(prefix + this.name + " (" + this.getSize() + ")");
    if (this.isDirectory) {
      for (FileNode child : this.children) {
        child.printNode(prefix + "|  ");
      }
    }
  }

  public ArrayList<Integer> getDirectorySizesFlat(ArrayList<Integer> sizes) {
    if (!this.isDirectory) {
      return sizes;
    }
    sizes.add(this.getSize());
    for (FileNode child : this.children) {
      child.getDirectorySizesFlat(sizes);
    }
    return sizes;
  }
}
