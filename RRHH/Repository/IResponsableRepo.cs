using RRHH.Models;

namespace RRHH.Repository
{
    public interface IResponsableRepo
    {
        public string Insertar(Responsable categoria);
        public string Modificar(Responsable categoria);
        public Responsable Obtener(int iResponsable);
        public IEnumerable<Responsable> ObtenerTodos();
        public string Eliminar(int iResponsable);
    }
}
