use std::env;
use std::fs::File;
use std::io::{self, prelude::*, BufReader};

fn main() -> io::Result<()> {
    // Usage: cargo run -- <input file>
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        println!("Usage: {} <file>", args[0]);
        return Ok(());
    }

    let file = File::open(&args[1])?;
    let reader = BufReader::new(file);

    // Could use lines().collect() directly for a Vec<Result<String, Error>>
    let lines: Vec<String> = reader.lines().map(|l| l.expect("Could not parse line")).collect();

    part1(&lines).unwrap();
    part2(&lines).unwrap();

    Ok(())
}

fn part1(lines: &Vec<String>) -> io::Result<()> {
    // All misplaced characters, one char per line of input
    let mut misplaced = "".to_string();

    for line in lines {
        let (left, right) = line.split_at(line.len() / 2);

        // Find the character that occurs in both halves
        for c in left.chars() {
            if right.contains(c) {
                // The character exists in both halves.
                misplaced.push(c);
                break;
            }
        }
    }

    println!("== Part 1 ==");
    println!("Misplaced characters: {}", misplaced);

    let score = find_score(misplaced);

    println!("Score: {}\n", score);

    Ok(())
}

fn part2(lines: &Vec<String>) -> io::Result<()> {
    let mut badges = "".to_string();

    let mut chunk = Vec::new();
    for line in lines {
        let line = line;
        chunk.push(line);

        // After reading 3 lines, find the recurring character and clear the chunk
        if chunk.len() == 3 {
            for c in chunk[0].chars() {
                if chunk[1].contains(c) && chunk[2].contains(c) {
                    // The character exists in all 3 lines.
                    badges.push(c);
                    break;
                }
            }

            chunk = Vec::new();
        }
    }

    println!("== Part 2 ==");
    println!("Badges: {}", badges);

    let score = find_score(badges);
    
    println!("Score: {}\n", score);

    Ok(())
}

fn find_score(badges: String) -> u32 {
    // Returns the sum of points.
    // Lower case letters are mapped a-z -> 1-26
    // Upper case letters are mapped A-Z -> 27-52

    let mut score = 0;

    for c in badges.chars() {
        if c.is_uppercase() {
            score += (c as u8 - b'A') as u32 + 27;
        } else {
            score += (c as u8 - b'a') as u32 + 1;
        }
    }

    score
}
