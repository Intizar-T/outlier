const sharp = require("sharp");
const readline = require("readline");

// Create an interface to get input from the console
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

async function processImage(imagePath) {
  try {
    const image = sharp(imagePath);
    const metadata = await image.metadata();
    const resizedImageBuffer = await image.resize(10, 10).toBuffer();
    const base64Image = resizedImageBuffer.toString("base64");
    const mimeType = metadata.format
      ? `image/${metadata.format}`
      : "image/jpeg";
    const dataUrl = `data:${mimeType};base64,${base64Image}`;
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
      console.log("Data URL:", dataUrl);
    }
    rl.close(); // Close the readline interface when done
  });
});
