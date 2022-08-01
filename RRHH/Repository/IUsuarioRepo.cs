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
        public IEnumerable<Usuario> ObtenerUsuarios(int perfil_id);
        public string Eliminar(string UsuarioID);
        public IEnumerable<Perfil> ObtenerPerfiles();

        public string ActalizarGUID(string usuario_id, string sitio_web, string guid);
        public Usuario LoginPorGuid(string sitio_web, string guid);
        public IEnumerable<Web> ObtenerWebs(string usuario_id);
        public string InsertarWeb(string UsuarioID, string web, int perfil_id);
        public string EliminarWeb(string UsuarioID, string web);


    }
}
