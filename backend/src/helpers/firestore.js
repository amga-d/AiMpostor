export const checkDocExists = async (
  docRef,
  errorMessage = "Document does not exist"
) => {
  const docSnap = await docRef.get();
  if (!docSnap.exists) {
    console.log(`${errorMessage} : ${docRef.path}`);
    throw Error(errorMessage);
  }
  return docSnap;
};

export const checkCollectionExists = async (
  collectionRef,
  errorMessage = "Collection does not exist"
) => {
  const collectionSnap = await collectionRef.get();
  if (collectionSnap.empty) {
    console.log(`${errorMessage} : ${collectionRef.path}`);
    throw Error(errorMessage);
  }
  return collectionSnap;
};
