using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoRepo
    {
        public string Insertar(Legajo legajo);
        public string Modificar(Legajo legajo);
        public Legajo Obtener(int id);
        public Legajo ObtenerPorNro(int empresa_id, int iNroLegajo);
        public IEnumerable<Legajo> ObtenerTodos(int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido);
        public IEnumerable<Legajo> ObtenerPagina(int pag, int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido);
        public int ObtenerCantidad(int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido);
        public IEnumerable<Legajo> ObtenerPorFiltro(string sFiltro);

        public string Eliminar(int id);
    }
}
