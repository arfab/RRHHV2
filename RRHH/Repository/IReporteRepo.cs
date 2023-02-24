﻿using RRHH.Models;

namespace RRHH.Repository
{
    public interface IReporteRepo
    {
        public IEnumerable<Viatico> ReporteViaticos(int empresa_id, int ubicacion_id, int sector_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta);

    }
}
