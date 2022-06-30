using RRHH.Models;

namespace RRHH.Repository
{
    public interface IFichadaRepo
    {
        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int tipo_listado);

    }
}
