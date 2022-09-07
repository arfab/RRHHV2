using RRHH.Models;

namespace RRHH.Repository
{
    public interface IJustificacionRepo
    {
        public string Insertar(Justificacion justificacion, int usuario_id);
        public string Modificar(Justificacion justificacion, int usuario_id);
        public Justificacion Obtener(int id);
        public IEnumerable<Justificacion> ObtenerPorLegajo(int legajo_id);
        public IEnumerable<Justificacion> ObtenerTodos(int empresa_id, int categoria_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido);
        public string Eliminar(int id);
    }
}
