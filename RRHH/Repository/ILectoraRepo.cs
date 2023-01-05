using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILectoraRepo
    {
        public string Insertar(Lectora lectora);

        public string Modificar(Lectora lectora);

        public string Eliminar(int nro_equipo);

        public Lectora Obtener(int iId);

        public IEnumerable<Lectora> ObtenerTodos();

        public IEnumerable<AjusteLectora> ObtenerAjustes(string fecha, int lectora_id);

        public int ObtenerAjustePorFecha(int lectora_id, DateTime fecha);

        public AjusteLectora ObtenerAjuste(int iId);

        public string InsertarAjuste(AjusteLectora ajuste);

        public string ModificarAjuste(AjusteLectora ajuste);

        public string EliminarAjuste(int iAjuste);

    }
}
