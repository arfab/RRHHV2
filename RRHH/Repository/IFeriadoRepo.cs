using RRHH.Models;


namespace RRHH.Repository
{
    public interface IFeriadoRepo
    {
        public string Insertar(Feriado feriado);
        public string Modificar(Feriado feriado);
        public IEnumerable<Feriado> ObtenerTodos(int iAnio, string sTipo);
        public Feriado Obtener(int iFeriado);
        public string Eliminar(int iFeriado);
        public IEnumerable<int> ObtenerAnios();

    }
}
