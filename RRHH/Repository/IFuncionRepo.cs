using RRHH.Models;

namespace RRHH.Repository
{
    public interface IFuncionRepo
    {
        public string Insertar(Funcion funcion);
        public string Modificar(Funcion funcion);
        public Funcion Obtener(int iFuncion);
        public IEnumerable<Funcion> ObtenerTodos();
        public string Eliminar(int iFuncion);
    }
}
