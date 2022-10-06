using RRHH.Models;

namespace RRHH.Repository
{
    public interface IRemotoRepo
    {
        public string Insertar(Remoto remoto, int usuario_id);
        public string Modificar(Remoto remoto, int usuario_id);
        public Remoto Obtener(int id);
        public IEnumerable<Remoto> ObtenerPorLegajo(int legajo_id);
        public IEnumerable<Remoto> ObtenerTodos(int empresa_id, int categoria_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido);
        public string Eliminar(int id);
    }
}
