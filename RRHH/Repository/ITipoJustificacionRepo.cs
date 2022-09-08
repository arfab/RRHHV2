using RRHH.Models;


namespace RRHH.Repository
{
    public interface ITipoJustificacionRepo
    {

        public string Insertar(TipoJustificacion tipoJustificacion);
        public string Modificar(TipoJustificacion tipoJustificacion);
        public TipoJustificacion Obtener(int iTipoJustificacion);
        public IEnumerable<TipoJustificacion> ObtenerTodos();
        public string Eliminar(int iTipoJustificacion);
    }
}
