using RRHH.Models;

namespace RRHH.Repository
{
    public interface INovedadRepo
    {
        public string Insertar(Novedad novedad);
        public string Modificar(Novedad novedad);
        public Novedad Obtener(int id);
        public IEnumerable<Novedad> ObtenerTodos(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id);        public string Eliminar(int id);
    }
}
