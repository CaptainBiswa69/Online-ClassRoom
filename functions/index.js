const functions = require("firebase-functions");
const express = require("express");
const app = express();
const { PythonShell } = require("python-shell");
const bodyParser = require("body-parser");

app.use(bodyParser.json());

app.get("/demo", (req, res) => {
  res.send("Hello");
});

// Define a route for plagiarism detection
app.post("/check-plagiarism", (req, res) => {
  try {
    const { basePdfLink, pdfLinks } = req.body;

    // Run the Python plagiarism detection script
    const options = {
      mode: "text",
      scriptPath: "./", // Specify the path to your Python script
      args: [basePdfLink, ...pdfLinks], // Pass basePdfLink as the first argument
    };

    PythonShell.run("plagiarism_detection.py", options)
      .then((results) => {
        res.json({ results });
      })
      .catch((err) => {
        console.error("Error running Python script:", err);
        res.status(500).json({
          error:
            "An error occurred while running the plagiarism detection script.",
        });
      });
  } catch (err) {
    console.log(err);
  }
});

exports.app = functions.https.onRequest(app);
