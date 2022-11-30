using RRHH.Models;


namespace RRHH.Repository
{
    public interface ITipoHorarioRepo
    {
        public IEnumerable<TipoHorario> ObtenerTodos(int? ubicacion_id, int? sector_id, int? legajo_id, int? tipo_hora_id);

    }
}
