using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoRepo
    {
        public string Insertar(Legajo legajo);
        public string Modificar(Legajo legajo);
        public Legajo Obtener(int id);
        public Legajo ObtenerPorNro(int empresa_id, int iNroLegajo);
        public IEnumerable<Legajo> ObtenerTodos(int empresa_id, int iNroLegajo, string sApellido);
        public string Eliminar(int id);
    }
}
