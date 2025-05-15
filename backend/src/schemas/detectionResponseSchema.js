// Define the JSON Schema for the structured response
const diseaseSchema = {
  type: "object",
  properties: {
    crop: {
      type: "string",
      description: "The name of the crop (e.g., Rice, Wheat).",
    },
    detectedDisease: {
      type: "string",
      description: "The name of the detected disease (e.g., Bacterial Leaf).",
    },
    riskLevel: {
      type: "string",
      description: "The risk level associated with the disease (e.g., High, Medium, Low).",
    },
    aboutDisease: {
      type: "string",
      description: "Information about the disease and its effects.",
    },
    recommendedAction: {
      type: "array",
      items: {
        type: "string",
        description: "A recommended action to mitigate the disease.",
      },
      description: "List of recommended actions to address the disease.",
    },
  },
  required: ["crop", "detectedDisease", "riskLevel", "aboutDisease", "recommendedAction"],
};

export default diseaseSchema;
