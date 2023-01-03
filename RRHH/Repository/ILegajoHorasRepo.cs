using RRHH.Models;


namespace RRHH.Repository
{
    public interface ILegajoHorasRepo
    {
        public string Insertar(int legajo_id, LegajoHoras legajoHoras);
        public string Modificar(LegajoHoras legajoHoras);
        public string Eliminar(int id);
        public LegajoHoras Obtener(int id);
        public IEnumerable<LegajoHoras> ObtenerTodos(int turno_id);


    }
}
