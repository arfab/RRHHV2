using RRHH.Models;


namespace RRHH.Repository
{
    public interface ITipoNovedadRepo
    {
        public string Insertar(TipoNovedad tipoNovedad);
        public string Modificar(TipoNovedad tipoNovedad);
        public TipoNovedad Obtener(int iTipoNovedad);
        public IEnumerable<TipoNovedad> ObtenerTodos();
        public string Eliminar(int iTipoNovedad);
    }
}
