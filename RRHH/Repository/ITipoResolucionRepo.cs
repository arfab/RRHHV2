using RRHH.Models;

namespace RRHH.Repository
{
    public interface ITipoResolucionRepo
    {
        public string Insertar(TipoResolucion tipoResolucion);
        public string Modificar(TipoResolucion tipoResolucion);
        public TipoResolucion Obtener(int iTipoResolucion);
        public IEnumerable<TipoResolucion> ObtenerTodos();
        public string Eliminar(int iTipoResolucion);
    }
}
