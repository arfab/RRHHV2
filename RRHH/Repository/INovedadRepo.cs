using RRHH.Models;

namespace RRHH.Repository
{
    public interface INovedadRepo
    {
        public string Insertar(Novedad novedad);
        public string Modificar(Novedad novedad);
        public Novedad Obtener(int id);
        public IEnumerable<Novedad> ObtenerTodos(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta);
        public string Eliminar(int id);
    }
}
