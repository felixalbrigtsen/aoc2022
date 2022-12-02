#include <stdio.h>

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Usage: %s <input filename>", argv[0]);
    return 1;
  }

  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("Could not open file %s", argv[1]);
    return 1;
  }

  // Each line looks like this:
  // A X
  // One byte Action, one space, one byte Reaction
 
  int score_1 =  0;
  int score_2 =  0;

  char line[5];

  while (fgets(line, sizeof(line), fp)) {

    char action = line[0] - 'A'; // Map A-C to 0-2
    char reaction = line[2] - 'X'; // Map X-Z to 0-2

    // Points for reaction
    score_1 += reaction + 1;

    // Points for win/draw/lose
    int points[] = {3,6,0}; // tie, win, lsoe
    score_1 += points[(reaction - action + 3) % 3];
    
    // Part 2
    char winstate = reaction;

    score_2 += winstate*3;
    score_2 += (action + (winstate+2)) % 3 + 1;

  }

  fclose(fp);

  printf("Part 1 Score: %d\n", score_1);
  printf("Part 2 Score: %d\n", score_2);
  return 0;
}


/* int simplifiedSolution(char action, char reaction) { */
/*   int score_1 = 0; */
/*   int score_2 = 0; */

/*   score_1 += reaction + 1; */
/*   if ((reaction - action + 3) % 3 == 1) { */
/*     // Win */
/*     score_1 += 6; */
/*   } else if (action == reaction) { */
/*     // Draw */
/*     score_1 += 3; */
/*   } else { */
/*     // Lose */
/*   } */

/*   if (winstate == 0) { */
/*     // Need to lose */
/*     score_2 += 0; */
/*     score_2 += (action+2) % 3; */
/*   } else if (winstate == 1) { */
/*     // Need to draw */
/*     score_2 += 3; */
/*     score_2 += action; */
/*   } else { */
/*     // Need to win */
/*     score_2 += 6; */
/*     score_2 += ((action+1) % 3); */
/*   } */
/*   score_2 += 1; // Because of zero indexing */
/* } */
