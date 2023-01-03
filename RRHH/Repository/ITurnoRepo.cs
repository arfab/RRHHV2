using RRHH.Models;

namespace RRHH.Repository
{
    public interface ITurnoRepo
    {
        public string Insertar(Turno turno);
        public string Modificar(Turno turno);
        public string Eliminar(int id);
        public Turno Obtener(int id);
        public IEnumerable<Turno> ObtenerTodos(int? ubicacion_id);


    }
}
