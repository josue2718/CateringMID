import React from "react";
import { logout } from "../api/auth";
import { Routes, Route } from "react-router-dom";
import ServiciosEnEsperaContainer from "./ServicioEnEsperaContainer";
import ServicioDetailContainer from "./ServicioDetailContainer";

const Home = ({ usuario, onLogout }) => {
  return (
    <div>
      <h1>Bienvenido, {usuario?.nombre || "Usuario"}</h1>
      
      <Routes>
        <Route path="/" element={<ServiciosEnEsperaContainer />} />
        <Route path="/servicio/:id" element={<ServicioDetailContainer />} />
        <Route path="/servicios" element={<ServiciosEnEsperaContainer />} />
      </Routes>
      
      <button onClick={onLogout}>Cerrar Sesión</button>
    </div>
  );
};

export default Home;


// import React from "react";
// import { logout } from "../api/auth";

// const Home = ({ usuario, onLogout }) => {
//   return (
//     <div>
//       <h2>Bienvenido {usuario.email}!</h2>
//       <button onClick={onLogout}>Cerrar sesión</button>
//     </div>
//   );
// };

// export default Home;
