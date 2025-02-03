import React, { useState } from "react";
import { fetchReservaById } from "../api/data";
import ServicioDetail from "./ServicioDetail";
import { useParams } from "react-router-dom";

const ServicioDetailContainer = ({}) => {
 {
        const [servicio, setServicio] = useState(null);
    const id = useParams().id;
        useEffect(() => {
            fetchReservaById(Number(id_reserva))
            .then((res) => {
                setServicio(res);
            })
        }, [])
        
    }
    return (
        <div>
            {servicio && <ServicioDetail servicio={servicio}/>}
        </div>
    )
}

export default  ServicioDetailContainer