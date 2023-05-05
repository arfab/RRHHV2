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
        public IEnumerable<Usuario> ObtenerUsuarios(int perfil_id, int perfil2_id);
        public string Eliminar(string UsuarioID);
        public IEnumerable<Perfil> ObtenerPerfiles();

        public string ActalizarGUID(string usuario_id, string sitio_web, string guid);
        public Usuario LoginPorGuid(string sitio_web, string guid);
        public IEnumerable<Web> ObtenerWebs(string usuario_id);
        public string InsertarWeb(string UsuarioID, string web, int perfil_id);
        public string EliminarWeb(string UsuarioID, string web);

        public string HomeOfficeFichar(int legajo_id, string tipo_fichada);
        public DateTime? HomeOfficeObtenerEntrada(int legajo_id);
        public DateTime? HomeOfficeObtenerSalida(int legajo_id);

        public int HomeOfficeObtenerCantidadEntradas(int legajo_id);
        public int HomeOfficeObtenerCantidadSalidas(int legajo_id);

    }
}
