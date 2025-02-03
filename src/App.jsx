import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./components/Login";
import Register from "./components/Register";
import Home from "./components/Home";
import Navbar from "./components/Navbar";
import Sidebar from "./components/Sidebar";
import { getToken, logout } from "./api/auth";

const App = () => {
  const [usuario, setUsuario] = useState(null);
  const [isRegistering, setIsRegistering] = useState(false);

  useEffect(() => {
    const token = getToken();
    if (token) {
      setUsuario({ token });
    }
  }, []);

  return (
    <Router>
      <div className="app-container">
        {usuario ? (
          <>
            <Navbar />
            <Sidebar />
            <Home usuario={usuario} onLogout={() => { logout(); setUsuario(null); }} />
          </>
        ) : isRegistering ? (
          <Register setIsRegistering={setIsRegistering} />
        ) : (
          <Login setIsRegistering={setIsRegistering} onLoginSuccess={setUsuario} />
        )}
      </div>
    </Router>
  );
};

export default App;


{/* <Routes>
  <Route path="/" element={<ServicioEnEsperaContainer />}/>
  <Route path="/servicio//:id" element={<ServicioDetailContainer />}/>
  <Route path="/Servicios" element={<ServicioEnEsperaContainer />}/>
</Routes> */}
