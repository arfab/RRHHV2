using RRHH.Models;

namespace RRHH.Repository
{
    public interface IResponsableRepo
    {
        public IEnumerable<Responsable> ObtenerTodos();
        public Responsable Obtener(int iResponsable);
    }
}
