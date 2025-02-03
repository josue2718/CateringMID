import React, { useEffect, useState } from "react";
import { fetchReservas } from "../api/data";
import ServiciosEnEspera from "./ServicioEnEspera";

const ServiciosEnEsperaContainer = () => {
    const [servicios, setServicios] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchReservas()
            .then((res) => {
                setServicios(res);
                setLoading(false);
            })
            .catch((err) => {
                setError("Error al cargar los servicios");
                setLoading(false);
            });
    }, []);

    if (loading) return <p>Cargando...</p>;
    if (error) return <p>{error}</p>;

    return (
        <div>
            <ServiciosEnEspera servicios={servicios} />
        </div>
    );
};

export default ServiciosEnEsperaContainer;
