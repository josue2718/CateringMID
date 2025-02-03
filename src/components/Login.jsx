import React, { useState } from "react";
import { login } from "../api/auth"; //se importa la funcion

const Login = ({ setIsRegistering, onLoginSuccess }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(""); 

    try {
      const userData = await login(email, password);
      onLoginSuccess(userData); // Guardamos usuario en el estado de App
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="form-box Login">
      <h2>LOGIN</h2>
      <form onSubmit={handleSubmit}>
        <div className="input-box">
          <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
          <label>Email</label>
        </div>
        <div className="input-box">
          <input type="password" required value={password} onChange={(e) => setPassword(e.target.value)} />
          <label>Password</label>
        </div>
        {error && <p style={{ color: "red" }}>{error}</p>}
        <div className="input-box">
          <button className="btn" type="submit">Login</button>
        </div>
        <div className="regi-link">
          <p>No tienes cuenta? <a href="#" onClick={() => setIsRegistering(true)}>Sign Up</a></p>
        </div>
      </form>
    </div>
  );
};

export default Login;
