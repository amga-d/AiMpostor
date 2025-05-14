import {Router} from "express"
import { verifyUser } from "../middlewares/userMiddleware.js";
import { generateFertilizerRecipe } from "../ai/fretilizerRecipeAi.js";
import { error } from "ajv/dist/vocabularies/applicator/dependencies.js";
const router = Router()

// get A fertilizer recipe
router.post("/",verifyUser, async(req, res) => {

  if (!req.body) {
    return res.status(400).json({ er: "Plant and available materials are required" });
  }
  const { plant, availableMaterials } = req.body;

  if (!plant || !availableMaterials) {
    return res.status(400).json({ error: "Plant and available materials are required" })
  } 
  try {
    const response  =  await generateFertilizerRecipe(plant, availableMaterials);
    if (response.message == "success") {
      return res.status(200).json({
        response
      })
    }
    else if (response.message == 'Invalid input'){
      return res.status(400).json({ error: response.error });
    }
    else{
      if (response.error) {
        return res.status(400).json({ error: response.error }); 
      }
      return res.status(500).json({ error: "Internal server error" });
    }
  } catch (error) {
    console.error("Error generating fertilizer recipe:", error);
    return res.status(500).json({ error: "Internal server error" });  
  }
  })


export default router