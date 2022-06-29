using RRHH.Models;

namespace RRHH.Repository
{
    public interface IFichadaRepo
    {
        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int tipo_listado);

    }
}
