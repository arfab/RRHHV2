using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILegajoRepo
    {
        public string Insertar(Legajo legajo);
        public string Modificar(Legajo legajo);
        public Legajo Obtener(int iNroLegajo);
        public IEnumerable<Legajo> ObtenerTodos();
        public string Eliminar(int iNroLegajo);
    }
}
