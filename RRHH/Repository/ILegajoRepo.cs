using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoRepo
    {
        public string Insertar(Legajo legajo);
        public string Modificar(Legajo legajo);
        public Legajo Obtener(int id);
        public Legajo ObtenerPorNro(int empresa_id, int iNroLegajo);
        public IEnumerable<Legajo> ObtenerTodos(int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido, int activo);
        public IEnumerable<Legajo> ObtenerPagina(int pag, int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido, int activo);
        public int ObtenerCantidad(int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido, int activo);
        public IEnumerable<Legajo> ObtenerPorFiltro(string sFiltro);

        public int ObtenerDeImportacion(string nro_legajo, string apellido, string nombre, string empresa, string sector, string categoria, string funcion, string fecha_alta, string fecha_baja, string genero, string observacion, string ubicacion_id,ref Legajo legajo);

        public string Eliminar(int id);
    }
}
