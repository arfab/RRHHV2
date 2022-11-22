using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILectoraRepo
    {

        public IEnumerable<Lectora> ObtenerTodos();

        public IEnumerable<AjusteLectora> ObtenerAjustes(string fecha, int lectora_id);

        public int ObtenerAjustePorFecha(int lectora_id, DateTime fecha);

        public AjusteLectora ObtenerAjuste(int iId);

        public string InsertarAjuste(AjusteLectora ajuste);

        public string ModificarAjuste(AjusteLectora ajuste);

        public string EliminarAjuste(int iAjuste);

    }
}
