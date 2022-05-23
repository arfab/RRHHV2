using RRHH.Models;


namespace RRHH.Repository
{
    public interface ICategoriaRepo
    {
        public string Insertar(Categoria categoria);
        public string Modificar(Categoria categoria);
        public Categoria Obtener(int iCategoria);
        public IEnumerable<Categoria> ObtenerTodos();
        public string Eliminar(int iCategoria);
    }
}
