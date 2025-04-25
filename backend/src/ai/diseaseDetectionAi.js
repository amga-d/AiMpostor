import Ajv from "ajv";
import diseaseSchema from "../schemas/detectionResponseSchema.js";
import {
  getmModelInstance,
  generationConfig,
  safetySettings,
  toolConfig,
  chatbotSysInstruction,
} from "../config/genAiConfig.js";

// Function to generate a structured response from Gemini
async function generateDiseasePrediction(imageContent, previousMessages = []) {
  const model = getmModelInstance();
  const ModelConfig = generationConfig();
  const chat = model.startChat({
    ...ModelConfig,
    safetySettings,
    tools: [toolConfig],
    history: previousMessages, // Use previous messages for chat history
  });

  const prompt = `You are an expert plant pathologist specializing in identifying plant diseases from images. You must analyze the provided image and use the 'predict_plant_disease' tool to provide your analysis. DO NOT generate the JSON response directly. YOU MUST use the provided tool function.

Analyze the following image of a plant and use the 'predict_plant_disease' tool to predict potential diseases.

Provide disease predictions, including the disease name, confidence level, a description of the symptoms observed, mitigation steps, and recommendations in a language that a farmer can easily understand.

If the image does not contain a plant, respond with a message explaining that you could not identify a plant in the image. Do not use the 'predict_plant_disease' tool in this case.
`;

  const parts = [{ text: prompt }, { inlineData: imageContent }];

  try {
    const result = await chat.sendMessage(parts);

    const response = result.response;

    if (response.candidates && response.candidates.length > 0) {
      const content = response.candidates[0].content;

      if (content.parts && content.parts.length > 0) {
        const functionCall = response.functionCalls();
        if (functionCall[0]) {
          const functionName = functionCall[0].name;
          const argumentsData = functionCall[0].args;
          if (functionName === "predict_plant_disease") {
            try {
              const ajv = new Ajv();
              const validate = ajv.compile(diseaseSchema);
              // console.log("Arguments data before validation:", argumentsData);
              const valid = validate(argumentsData);

              if (!valid) {
                console.error("Validation errors:", validate.errors);
                throw new Error("JSON Schema validation failed");
              }

              return argumentsData;
            } catch (error) {
              console.error("Error validating response:", error);
              return { error: "Invalid response format. Please try again." }; // Farmer-friendly error
            }
          }
        } else {
          // If no function call, assume it's the "not a plant" response
          return { message: content.parts[0].text };
        }
      }
    }

    return { message: "I couldn't analyze the image. Please try again." }; // Generic fallback
  } catch (error) {
    console.error("Error generating response:", error);
    return {
      error:
        "There was an error processing your request. Please try again later.",
    };
  }
}

async function generateContentResponse(previousMessages, message) {
  const model = getmModelInstance(chatbotSysInstruction);
  const ModelConfig = generationConfig(0.6, 1000);
  const chat = model.startChat({
    ...ModelConfig,
    safetySettings,
    history: previousMessages,
  });

  try {
    const result = await chat.sendMessage(message);
    const responseText = result.response.text();
    return responseText;
  } catch (error) {
    console.error("Error generating content response:", error);
    return {
      error:
        "There was an error processing your request. Please try again later.",
    };
  }
}

export { generateDiseasePrediction, generateContentResponse };
