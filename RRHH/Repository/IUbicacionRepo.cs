using RRHH.Models;


namespace RRHH.Repository
{
    public interface IUbicacionRepo
    {
        public IEnumerable<Ubicacion> ObtenerTodos();
        public Ubicacion Obtener(int iUbicacion);
    }
}
