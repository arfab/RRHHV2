using RRHH.Models;

namespace RRHH.Repository
{
    public interface IRemotoRepo
    {
        public string Insertar(Remoto remoto);
        public string Modificar(Remoto remoto);
        public Remoto Obtener(int id);
        public IEnumerable<Remoto> ObtenerPorLegajo(int legajo_id);
        public IEnumerable<Remoto> ObtenerTodos(int empresa_id, int dia_semana, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta, string apellido);
        public string Eliminar(int id);
    }
}
