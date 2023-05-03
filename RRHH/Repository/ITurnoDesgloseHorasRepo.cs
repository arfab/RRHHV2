using RRHH.Models;

namespace RRHH.Repository
{
    public interface ITurnoDesgloseHorasRepo
    {

        public string Insertar(int turno_id, TurnoDesgloseHoras turnoDesgloseHoras);
        public string Modificar(TurnoDesgloseHoras turnoDesgloseHoras);
        public string Eliminar(int id);
        public TurnoDesgloseHoras Obtener(int id);
        public IEnumerable<TurnoDesgloseHoras> ObtenerTodos(int turno_id);

    }
}
