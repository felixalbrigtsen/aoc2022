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
    FileNode root = fileSystemReader.getRoot();
    root.printNode("");
    System.out.println("\nTotal size: " + root.getSize() + "\n\n");

    Integer directorySizeSum = 0;

    ArrayList<Integer> directorySizes = root.getDirectorySizesFlat(new ArrayList<Integer>());
    for (Integer size : directorySizes) {
      if (size <= 100000) {
        directorySizeSum += size;
      }
    }

    // Java 8 alternative:
    // Predicate<Integer> isLarge = (size) -> size <= 1000000;
    // directorySizeSum = directorySizes.stream().filter(isLarge).reduce(0, (a, b) -> a + b);

    System.out.println("Part 1: " + directorySizeSum);

    // Part 2
    Integer maxUsedSpace = 70000000 - 30000000;
    Integer p2_usedSpace = root.getSize();

    Collections.sort(directorySizes);

    for (Integer size : directorySizes) {
      if (p2_usedSpace - size <= maxUsedSpace) {
        System.out.println("Part 2: " + size);
        break;
      }
    }
  }
}
