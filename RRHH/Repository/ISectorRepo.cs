using RRHH.Models;

namespace RRHH.Repository
{
    public interface ISectorRepo
    {
        public string Insertar(Sector sector);
        public string Modificar(Sector sector);
        public Sector Obtener(int iSector);
        public IEnumerable<Sector> ObtenerTodos();
        public string Eliminar(int iSector);
    }
}
