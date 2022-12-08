let forest = [];
let rows;
let cols;
const scale = 20;
let rotate = true;

let planeSize = 400;
let scannerHeight = scale*12;

let visibleTrees = [];
let checkedTrees = [];

let textures = {
  snow: null,
  tree: null,
}

function preload() {
  textures.snow = loadImage("assets/snow.jpg");
  textures.tree = loadImage("assets/tree.jpg");
};

let cameraParams = [0, 300, 150, 0, 0, 50, 0, 1, 0];

async function loadForest(filename) {
  let text;
  try {
    let data = await fetch("data/" + filename);
    text = await data.text();
  } catch (e) {
    console.log("Error loading forest data: " + e);
    return;
  }

  let lines = text.split("\n").slice(0, -1);
  let trees = lines.map((line) => line.split("").map((char) => parseInt(char)));

  rows = trees.length;
  cols = trees[0].length;
  return trees;
}

function initScene() {
  background(50);
  stroke(255);
  strokeWeight(1);
  texture(textures.snow);

  if (rotate) {
    rotateZ(frameCount * 0.01);
  }

  // Draw the ground plane
  plane(planeSize, planeSize);

}

function drawTrees(forest) {
  fill(0, 150, 0);
  stroke(150, 75, 0);
  rectMode(CORNER);
  // texture(textures.tree);

  translate(-(cols + 1) * scale, -(rows-1) * scale);

  for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
      translate(scale*2, 0, 0);

      push();
      if (forest[i][j] > 0) {
        translate(0, 0, forest[i][j]*scale/2);

        if (visibleTrees.includes(getIndex(i, j))) {
          fill(0, 255, 0);
        } else if (checkedTrees.includes(getIndex(i, j))) {
          fill(255, 0, 0);
        }
        box(scale, scale, forest[i][j] * scale);
      }
      pop();
    }
    translate(-cols * 2 * scale, 2 * scale, 0);
  }
}

function drawScanner() {
  // Draw the scanner
  // rotate = false;
  push();
  fill(255, 0, 200);
  // demo: 100, -100 = planeSize/4, -planeSize/4
  translate(scale*(cols+1), -scale*(rows+1), scannerHeight);
  box(planeSize, planeSize, 2);
  pop();

  if (scannerHeight > -2) {
    scannerHeight -= 1;
  }
}

function getIndex(x, y) {
  return x*cols + y;
}

function checkVisible(z) {
  for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
      const index = getIndex(i, j);
      if (checkedTrees.includes(index)) {
        continue;
      }

      // Just check the specified height
      if (forest[i][j] !== z) {
        continue
      }
      checkedTrees.push(index);

      // All trees along the edge are visible
      if (i == 0 || i == rows-1 || j == 0 || j == cols-1) {
        visibleTrees.push(index);
        continue;
      }

      let visibleNorth = true;
      let visibleSouth = true;
      let visibleWest = true;
      let visibleEast = true;

      // Check if there are any trees in the way
      // Row-
      for (let k = i-1; k >= 0; k--) {
        if (forest[k][j] >= z) {
          visibleNorth = false;
          break;
        }
      }

      // Row+
      for (let k = i+1; k < rows; k++) {
        if (forest[k][j] >= z) {
          visibleSouth = false;
          break;
        }
      }

      // Col-
      for (let k = j-1; k >= 0; k--) {
        if (forest[i][k] >= z) {
          visibleWest = false;
          break;
        }
      }

      // Col+
      for (let k = j+1; k < cols; k++) {
        if (forest[i][k] >= z) {
          visibleEast = false;
          break;
        }
      }


      if (visibleNorth || visibleSouth || visibleWest || visibleEast) {
        visibleTrees.push(index);
      }
    }
  }
}


function getScenicScore(x, y) {
  let score = 1;
  const height = forest[x][y];

  if (x == 0 || x == rows-1 || y == 0 || y == cols-1) {
    return 0
  }

  let doneNorth = false;
  let doneSouth = false;
  let doneWest = false;
  let doneEast = false;

  for (let i = 1; i <= Math.max(rows, cols); i++) {
    if (!doneNorth) {
      if (x-i <= 0 || forest[x-i][y] >= height) {
        score *= i;
        doneNorth = true;
        // console.log("N", x, y, i);
      }
    }

    if (!doneSouth) {
      if (x+i >= rows-1 || forest[x+i][y] >= height) {
        score *= i;
        doneSouth = true;
        // console.log("S", x, y, i);
      }
    }

    if (!doneWest) {
      if (y-i <= 0 || forest[x][y-i] >= height) {
        score *= i;
        doneWest = true;
        // console.log("W", x, y, i);
      }
    }

    if (!doneEast) {
      if (y+i >= cols-1 || forest[x][y+i] >= height) {
        score *= i;
        doneEast = true;
        // console.log("E", x, y, i);
      }
    }

    if (doneNorth && doneSouth && doneWest && doneEast) {
      break;
    }
  }

  return score;

}

function scenicScores() {
  let scores = [];
  for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
      scores.push(getScenicScore(i, j));
    }
  }

  return scores;
}

async function setup() {
  createCanvas(800, 600, WEBGL);
  frameRate(30);

  forest = await loadForest("input.txt")
  planeSize = (Math.max(rows, cols) + 4) * scale * 2;
  // console.log(forest);

  camera(...cameraParams);

  let p2Scores = scenicScores();
  document.getElementById("scenicScore").innerHTML = Math.max(...p2Scores);
}

function draw() {
  orbitControl();
  initScene();
  drawTrees(forest);
  drawScanner();

  if (scannerHeight < scale*10 && scannerHeight % scale == 0) {
    console.log("Scanner height: " + (scannerHeight / scale));
    checkVisible(scannerHeight/scale);
  }

  // console.log(frameRate());

  document.getElementById("visibleTreeCount").innerHTML = visibleTrees.length;
}
