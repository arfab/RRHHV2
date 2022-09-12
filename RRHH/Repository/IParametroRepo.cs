using RRHH.Models;

namespace RRHH.Repository
{
    public interface IParametroRepo
    {
        public string Insertar(Parametro parametro);
        public string Modificar(Parametro parametro);
        public Parametro Obtener(string codigo);
        public string ObtenerValor(string codigo);
        public IEnumerable<Parametro> ObtenerTodos();
        public string Eliminar(string codigo);
    }
}
