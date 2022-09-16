using RRHH.Models;

namespace RRHH.Repository
{
    public interface IFichadaRepo
    {
        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int tipo_listado);

        public CantidadHoras ObtenerCantidadHoras(string entrada1, string salida1, string entrada2, string salida2, int ubicacion_id, int sector_id, int dia_semana);

    }
}
