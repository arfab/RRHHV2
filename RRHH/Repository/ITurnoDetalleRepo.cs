using RRHH.Models;

namespace RRHH.Repository
{
    public interface ITurnoDetalleRepo
    {
        public string Insertar(int turno_id, TurnoDetalle turnoDetalle);
        public string Modificar(TurnoDetalle turnoDetalle);
        public string Eliminar(int id);
        public TurnoDetalle Obtener(int id);
        public IEnumerable<TurnoDetalle> ObtenerTodos(int turno_id);

    }
}
