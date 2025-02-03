//"https://cateringmid.azurewebsites.net/swagger/api/Propietario_Empresa" 
//https://cateringmid.azurewebsites.net/api/Reservas
const API_URL = "https://cateringmid.azurewebsites.net/api"; // URL base

// Obtener lista de reservas
export const fetchReservas = async () => {
  try {
    const response = await fetch(`${API_URL}/Reservas`);
    if (!response.ok) throw new Error("Error al obtener reservas");
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al obtener reservas:", error);
    return []; // Retornar un array vacío si falla
  }
};

  
  // Obtener reserva por ID
  export const fetchReservaById = async (id) => {
    try {
      const response = await fetch(`${API_URL}/Reservas/${id}`);
      if (!response.ok) throw new Error("Reserva no encontrada");
      return await response.json();
    } catch (error) {
      console.error(error);
      throw error;
    }
  };

  // Obtener lista de reservas
export const fetchMenu = async () => {
  try {
    const response = await fetch(`${API_URL}/Menu`);
    if (!response.ok) throw new Error("Error al obtener reservas");
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al obtener reservas:", error);
    return []; // Retornar un array vacío si falla
  }
};