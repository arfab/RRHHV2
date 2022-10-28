using RRHH.Models;

namespace RRHH.Repository
{
    public interface IFichadaRepo
    {
        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int lectora_id, int tipo_listado);

        public CantidadHoras ObtenerCantidadHoras(string entrada1, string salida1, string entrada2, string salida2, string entrada3, string salida3, string entrada4, string salida4, int ubicacion_id, int sector_id, int dia_semana);

        public string InsertarExportacionFichada(int nro_lectora, int nro_legajo, DateTime fecha, string hora, string tipo, int completo);

        public IEnumerable<FichadaOriginal> ObtenerFichadasOriginales(int legajo_id, int lectora_id, string fecha, int sin_excluidos);

        public string ExcluirFichadas();

        public string GenerarFichadas(int alta_legajo);

    }
}
