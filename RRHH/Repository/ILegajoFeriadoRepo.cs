using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoFeriadoRepo
    {

        public string Insertar(LegajoFeriado legajoFeriado);
        public string Eliminar(int id);
        public IEnumerable<LegajoFeriado> ObtenerTodos(int feriado_id);

    }
}
