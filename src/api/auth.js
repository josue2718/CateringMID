// 🔹 Hacer login y obtener el token
export const login = async (email, password) => {
  try {
    const response = await fetch("https://cateringmid.azurewebsites.net/api/AuthPropietario/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ email, password }) // 🔹 Enviamos email y password
    });

    if (!response.ok) throw new Error("Usuario o contraseña incorrectos");

    const data = await response.json();
    
    if (data.token) {
      localStorage.setItem("token", data.token); // Guardamos el token
      return data;
    } else {
      throw new Error("No se recibió un token");
    }
  } catch (error) {
    console.error("Error en login:", error);
    throw error;
  }
};

// 🔹 Registrar un nuevo usuario
export const register = async (userData) => {
  try {
    const response = await fetch("https://cateringmid.azurewebsites.net/api/Propietario_Empresa", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(userData)
    });

    if (!response.ok) throw new Error("Error al registrar usuario");

    return await response.json();
  } catch (error) {
    console.error("Error en registro:", error);
    throw error;
  }
};

// 🔹 Obtener el token guardado
export const getToken = () => {
  return localStorage.getItem("token");
};

// 🔹 Cerrar sesión
export const logout = () => {
  localStorage.removeItem("token"); // Borra el token
};
