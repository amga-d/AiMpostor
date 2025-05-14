import { generationConfig, getModelInstance, recipeToolConfig, safetySettings } from "../config/genAiConfig.js";
import Ajv from "ajv";
import freitizerSchema from "../schemas/fertilizerRecipeResponseSchema.js";
// Function to generate a structured response from Gemini
async function generateFertilizerRecipe(plantName, availableMaterials) {
    // if (!plantName || typeof plantName !== 'string' || !plantName.trim()) {
    //     return { error: "Invalid request: Plant name is required and must be a valid string." };
    // }

    // if (!availableMaterials || !Array.isArray(availableMaterials) || availableMaterials.length === 0) {
    //     return { error: "Invalid request: Available materials must be a non-empty array." };
    // }

    const model = getModelInstance();
    const modelConfig = generationConfig();
    const chat = model.startChat({
        
            ...modelConfig,
            safetySettings,
            tools: [recipeToolConfig]
    })
    
    const prompt = `You are an expert agronomist specializing in providing fertilizer recommendations based on the plant name and available materials. You must analyze the provided input and use the 'predict_fertilizer_recipe' tool to generate your analysis. DO NOT generate the JSON response directly. YOU MUST use the provided tool function.

Analyze the following input:
Plant Name: ${plantName}
Available Materials: ${availableMaterials}

Use the 'predict_fertilizer_recipe' tool to provide a structured JSON response. The response should include a title, a list of ingredients with quantities and materials, and step-by-step instructions for creating the fertilizer. If the plant name or the available materials are not valid,MUST respond with an error message in JSON format: { "error": "Invalid input" }.`;

    try {
        const result = await chat.sendMessage(prompt);

        const response = await result.response
        console.log("Response from model:", response.text());
        console.log("Function call data:", );
        const functionCall = response.functionCalls();
        if (functionCall && functionCall.length > 0) {
            const functionName = functionCall[0].name;
            const argumentsData = functionCall[0].args;

            if (functionName === "predict_fertilizer_recipe") {
                try {
                    const ajv = new Ajv();
                    const validate = ajv.compile(freitizerSchema);
                    const valid = validate(argumentsData);

                    if (!valid) {
                        console.error("Validation errors:", validate.errors);
                        throw new Error("JSON Schema validation failed");
                    }
                    console.log(argumentsData);
                    return argumentsData;
                } catch (error) {
                    console.error("Error validating response:", error);
                    return { error: "Invalid response format. Please try again." };
                }
            }
        }
    } catch (error) {
        if (error.status === 503);
        console.log(error.status);
        console.error("Error generating fertilizer recipe:", error);
        return { error: "Invalid response format. Please try again." };
    }
}

export { generateFertilizerRecipe };