using RRHH.Models;


namespace RRHH.Repository
{
    public interface ITurnoHorasRepo
    {
        public string Insertar(int turno_id, TurnoHoras turnoHoras);
        public string Modificar(TurnoHoras turnoHoras);
        public string Eliminar(int id);
        public TurnoHoras Obtener(int id);
        public IEnumerable<TurnoHoras> ObtenerTodos(int turno_id);


    }
}
