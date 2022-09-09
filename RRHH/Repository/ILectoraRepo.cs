using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILectoraRepo
    {

        public IEnumerable<Lectora> ObtenerTodos();

        public int ObtenerAjuste(int lectora_id, DateTime fecha);

    }
}
