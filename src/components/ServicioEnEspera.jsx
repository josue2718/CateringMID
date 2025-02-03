import React from "react";
import Servicio from "./Servicio";

const ServiciosEnEspera = ({ servicios }) => {
    return (
        <div className="serviciosEspera">
            <h2 className="Titulo">Servicios en Cola</h2>
            <div className="Servicios">
                {servicios.length > 0 ? (
                    servicios.map((serv) => (
                        <div key={serv.id_reserva} className="reserva">
                            <h3>Reserva de: {serv.reserva_Info_Clientes[0]?.primer_nombre || "Desconocido"}</h3>
                            <p><strong>Fecha:</strong> {serv.fecha}</p>
                            <p><strong>Hora:</strong> {serv.hora}</p>
                            <p><strong>Costo:</strong> ${serv.costo}</p>
                            <p><strong>Dirección:</strong> {serv.reserva_direccions[0]?.calle || "No disponible"}</p>
                        </div>
                    ))
                ) : (
                    <p>No hay servicios en espera.</p>
                )}
            </div>
        </div>
    );
};

export default ServiciosEnEspera;
