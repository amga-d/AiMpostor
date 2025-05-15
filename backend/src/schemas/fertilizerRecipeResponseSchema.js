const RecipeSchema = {
  type: "object",
  properties: {
    message: {
      type: "string",
      description: "A message indicating the result of the operation, e.g., success or error",
    },
    data: {
      type: "object",
      properties: {
        plant: {
          type: "string",
          description: "The name of the plant for which the recipe is generated",
        },
        availableMaterials: {
          type: "array",
          items: {
            type: "string",
            description: "List of available materials provided for the recipe",
          },
        },
        recipe: {
          type: "object",
          properties: {
            title: {
              type: "string",
              description: "The title of the recipe, e.g., 'Suggested Fertilizer Recipe for Your Tomato Plant'",
            },
            ingredients: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  quantity: {
                    type: "string",
                    description: "The quantity of the ingredient, e.g., '2 parts'",
                  },
                  material: {
                    type: "string",
                    description: "The name of the material, e.g., 'banana peel'",
                  },
                },
                required: ["quantity", "material"],
              },
              description: "A list of ingredients with their quantities",
            },
            instructions: {
              type: "array",
              items: {
                type: "string",
                description: "Step-by-step instructions for preparing and applying the fertilizer",
              },
              description: "Instructions for mixing and applying the fertilizer",
            },
          },
          required: ["title", "ingredients", "instructions"],
        },
      },
      required: ["plant", "availableMaterials", "recipe"],
    },
  },
  required: ["message", "data"],
};

export default RecipeSchema;
