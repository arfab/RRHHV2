using RRHH.Models;

namespace RRHH.Repository
{
    public interface IUsuarioRepo
    {
        Usuario Login(string usuario, string clave);
        public string Insertar(Usuario usuario);
        public string Modificar(Usuario usuario);
        public string CambiarClave(Usuario usuario);
        public Usuario ObtenerUsuario(string UsuarioId);
        public IEnumerable<Usuario> ObtenerUsuarios();
        public string Eliminar(string UsuarioID);
        public IEnumerable<Perfil> ObtenerPerfiles();


    }
}
