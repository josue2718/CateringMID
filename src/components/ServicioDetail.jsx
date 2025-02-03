import React from "react";

const ServicioDetail = ( {servicios} ) => {
//el routeo en react se realiza con "Link" seguito de un to="/"
//en el to colocamos e
    return (
        <div className="container">
            <div className="servicio-detalle">
                <img src={servicios.imagen} alt={servicios.nombre} />
                <div>
                    <li><Link to="/"/></li>
                    <h3 className="titulo">{servicios.titulo}</h3>
                    <p className="descripcion">{servicios.descripcion}</p>
                    <p className="fecha">{servicios.fecha}</p>
                </div>
            </div>

        </div>
    )
}
export default ServicioDetail