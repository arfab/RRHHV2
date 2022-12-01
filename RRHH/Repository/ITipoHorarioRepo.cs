using RRHH.Models;


namespace RRHH.Repository
{
    public interface ITipoHorarioRepo
    {

        public string Insertar(TipoHorario tipoHorario);
        public string Modificar(TipoHorario tipoHorario);
        public string Eliminar(int id);
        public TipoHorario Obtener(int id);
        public IEnumerable<TipoHorario> ObtenerTodos(int? ubicacion_id, int? sector_id, int? legajo_id, int? tipo_hora_id);

    }
}
