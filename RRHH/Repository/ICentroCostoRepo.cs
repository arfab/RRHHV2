using RRHH.Models;

namespace RRHH.Repository
{
    public interface ICentroCostoRepo
    {
        public string Insertar(CentroCosto centroCosto);
        public string Modificar(CentroCosto centroCosto);
        public CentroCosto Obtener(int iCentroCosto);
        public IEnumerable<CentroCosto> ObtenerTodos();
        public string Eliminar(int iCentroCosto);
    }
}
