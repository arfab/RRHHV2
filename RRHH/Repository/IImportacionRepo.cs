using RRHH.Models;

namespace RRHH.Repository
{
    public interface IImportacionRepo
    {
        public string Insertar(Importacion importacion);
        public IEnumerable<Importacion> ObtenerTodos(string tipo);
    }
}
