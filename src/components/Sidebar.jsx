// Sidebar.jsx
import React from "react";
import "./Sidebar.css"; // Asegúrate de crear este archivo CSS

const Sidebar = ({ onLogout }) => {
  return (
    <div className="sidebar">
      <ul>
        <li><a href="/home">🏠 Inicio</a></li>
        <li><a href="/agregar">➕ Agregar</a></li>
        <li><a href="/agenda">📅 Agenda</a></li>
        <li><a href="/promociones">💰 Promociones</a></li>
        <li><a href="/ganancias">💲 Ganancias</a></li>
        <li><a href="/menu">🍽️ Menú</a></li>
      </ul>
      <button className="logout" onClick={onLogout}>🚪 Cerrar sesión</button>
    </div>
  );
};

export default Sidebar;