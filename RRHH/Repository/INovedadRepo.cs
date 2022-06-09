using RRHH.Models;

namespace RRHH.Repository
{
    public interface INovedadRepo
    {
        public string Insertar(Novedad novedad, int usuario_id);
        public string Modificar(Novedad novedad,int usuario_id);
        public Novedad Obtener(int id);
        public IEnumerable<Novedad> ObtenerTodos(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido);
        public IEnumerable<Novedad> ObtenerPagina(int pag, int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido);
        public int ObtenerCantidad(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido);
        public string Eliminar(int id);
    }
}
