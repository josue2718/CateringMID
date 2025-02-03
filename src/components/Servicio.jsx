import React from "react";
import ServicioDetailContainer from "./ServicioDetailContainer";
import { Link } from "react-router-dom";
const Servicio = ({servicios}) =>{
    return (
        <div className="Servicio">
            <img src={servicios.imagen} alt="" />
            <div>
                <h4>{servicios.titulo}</h4>
                <p>Precio: ${servicios.precio}</p>
                <p>fecha: {servicios.fecha}</p>
                <Link className="ver-mas" to={`/servicio/${servicios.id}`}>Detalles</Link>
            </div>
        </div>//modificar el interior para que cuadre con el body de la api
    )
}

export default Servicio