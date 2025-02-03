import React, { useState } from "react";
import { register } from "../api/auth";

const Register = ({ setIsRegistering }) => {
  const [formData, setFormData] = useState({
    email: "",
    password: "",
    nombre: "",
    apellido: "",
    telefono: "",
    rfc: "",
    clave: "",  // Agregado por si acaso
    link_imagen: "",  // Puede ser opcional, pero mejor lo agregamos
    fecha_de_creacion: new Date().toISOString(),  // Agregado y formateado
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await register(formData);
      alert("Registro exitoso, ahora puedes iniciar sesión");
      setIsRegistering(false);
    } catch (error) {
      console.error("Error en registro:", error);
      alert("Error al registrar usuario. Verifica los datos ingresados.");
    }
  };

  return (
    <div className="form-box Register">
      <h2>REGISTRO</h2>
      <form onSubmit={handleSubmit}>
        <input type="email" name="email" placeholder="Email" onChange={handleChange} required />
        <input type="password" name="password" placeholder="Contraseña" onChange={handleChange} required />
        <input type="text" name="nombre" placeholder="Nombre" onChange={handleChange} required />
        <input type="text" name="apellido" placeholder="Apellido" onChange={handleChange} required />
        <input type="text" name="telefono" placeholder="Teléfono" onChange={handleChange} required />
        <input type="text" name="rfc" placeholder="RFC" onChange={handleChange} required />
        <input type="text" name="clave" placeholder="Clave (opcional)" onChange={handleChange} />
        <input type="text" name="link_imagen" placeholder="Link de imagen (opcional)" onChange={handleChange} />
        <button type="submit">Registrar</button>
        <button type="button" onClick={() => setIsRegistering(false)}>Ya tengo cuenta</button>
      </form>
    </div>
  );
};

export default Register;
