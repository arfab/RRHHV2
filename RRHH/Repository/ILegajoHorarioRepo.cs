using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoHorarioRepo
    {
        public string Insertar(int legajo_id, LegajoHorario legajoHorario);
        public string Modificar(LegajoHorario legajoHorario);
        public LegajoHorario Obtener(int id);
        public IEnumerable<LegajoHorario> ObtenerPorLegajo(int legajo_id);
        public string Eliminar(int id);
    }
}
