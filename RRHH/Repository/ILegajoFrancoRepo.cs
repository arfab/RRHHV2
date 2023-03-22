using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoFrancoRepo
    {
        public string Insertar(int legajo_id, LegajoFranco legajoFranco);
        public string Modificar(LegajoFranco legajoFranco);
        public LegajoFranco Obtener(int id);
        public IEnumerable<LegajoFranco> ObtenerPorLegajo(int legajo_id);
        public string Eliminar(int id);
    }
}
