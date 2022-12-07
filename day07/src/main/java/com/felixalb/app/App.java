package com.felixalb.app;

import java.io.*;
import java.util.*;
import java.nio.file.*;


public class App {
  private static String[] readLines(String filename) {
    try {
      return Files.readAllLines(Paths.get(filename)).toArray(new String[0]);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static void main(String[] args) {
    if (args.length < 1) {
      System.out.println("Usage: java App <filename>");
      return;
    }

    String filename = args[0];
    String[] lines = readLines(filename);

    System.out.println("Lines: " + lines.length);

    FileSystemReader fileSystemReader = new FileSystemReader(lines);


    // Part 1
    FileNode p1_root = fileSystemReader.getRoot();
    Integer directorySizeSum = 0;
    ArrayList<Integer> p1_sizes = p1_root.getDirectorySizesFlat(new ArrayList<Integer>());
    // System.out.println("Part 1: " + p1_sizes);
    for (Integer size : p1_sizes) {
      if (size <= 100000) {
        directorySizeSum += size;
      }
    }
    p1_root.printNode("");
    System.out.println("Part 1: " + directorySizeSum);


  }
}
