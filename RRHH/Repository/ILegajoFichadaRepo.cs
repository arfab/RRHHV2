using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoFichadaRepo
    {
        public string Insertar(LegajoFichada legajoFichada, string modo);
        public string InsertarManual(LegajoFichada legajoFichada);
        public string Modificar(LegajoFichada legajoFichada);
        public LegajoFichada Obtener(int iID);
        public LegajoFichada ObtenerPorLegajo(int legajo_id, String fecha);
        public IEnumerable<LegajoFichada> ObtenerTodos();
        public string Eliminar(int iID);

    }
}
