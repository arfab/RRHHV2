using RRHH.Models;

namespace RRHH.Repository
{
    public interface IFichadaRepo
    {
        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int tipo_listado);

        public CantidadHoras ObtenerCantidadHoras(string entrada1, string salida1, string entrada2, string salida2, string entrada3, string salida3, int ubicacion_id, int sector_id, int dia_semana);

        public string InsertarExportacionFichada(int nro_lectora, int nro_legajo, DateTime fecha, string hora, string tipo, int completo);

    }
}
