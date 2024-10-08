const { createCanvas, loadImage } = require("canvas");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

async function processImage(imagePath) {
  try {
    // Load the image
    const img = await loadImage(imagePath);

    // Create a canvas with the desired dimensions
    const canvas = createCanvas(10, 10);
    const ctx = canvas.getContext("2d");

    // Draw the image onto the canvas, resizing it in the process
    ctx.drawImage(img, 0, 0, 10, 10);

    // Get the data URL from the canvas
    const dataUrl = canvas.toDataURL();

    return dataUrl;
  } catch (error) {
    console.error("Error processing image:", error);
    return null;
  }
}

// Ask the user to input the image path
rl.question("Please enter the absolute path to the image: ", (imagePath) => {
  processImage(imagePath).then((dataUrl) => {
    if (dataUrl) {
      console.info("Data URL:", dataUrl);
    }
    rl.close(); // Close the readline interface
  });
});
