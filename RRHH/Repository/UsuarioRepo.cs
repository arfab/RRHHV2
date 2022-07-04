using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using BCryptNet = BCrypt.Net.BCrypt;


namespace RRHH.Repository
{
    public class UsuarioRepo : IUsuarioRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();
        public Usuario Login(string login, string clave)
        {

            Usuario usuario = new Usuario();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@UsuarioID", login);
                //parameter.Add("@clave", BCryptNet.HashPassword(clave));
                usuario = con.QueryFirstOrDefault<Models.Usuario>("spLogin", parameter, commandType: CommandType.StoredProcedure);

            }

            //if (login.ToLower() == clave.ToLower() )
            //{
            //    usuario.UsuarioID = login.ToLower();
            //}

            if (usuario != null && BCrypt.Net.BCrypt.Verify(clave, usuario.clave))
                return usuario;
            else
                return null;


        }


        //public Usuario Login(string login, string clave)
        //{

        //    Usuario usuario = new Usuario();



        //    if (login.ToLower() == "admin" && clave.ToLower() == "admin987" || login.ToLower() == "ale" && clave.ToLower() == "ale123")
        //    {
        //        usuario.UsuarioID= login.ToLower();
        //    }
        //    return usuario;

        //}

        public string Insertar(Usuario usuario)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@UsuarioID", usuario.UsuarioID);
                parameters.Add("@clave", BCryptNet.HashPassword(usuario.clave));
                parameters.Add("@nombre", usuario.Nombre);
                parameters.Add("@apellido", usuario.Apellido);
                parameters.Add("@perfil_id", usuario.perfil_id);


                icantFilas = con.Execute("spUsuarioInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Usuario usuario)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@UsuarioID", usuario.UsuarioID);
                parameters.Add("@nombre", usuario.Nombre);
                parameters.Add("@apellido", usuario.Apellido);
                parameters.Add("@perfil_id", usuario.perfil_id);


                icantFilas = con.Execute("spUsuarioModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string CambiarClave(Usuario usuario)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@UsuarioID", usuario.UsuarioID);
                parameters.Add("@clave", BCryptNet.HashPassword(usuario.clave));



                icantFilas = con.Execute("spUsuarioCambiarClave", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public IEnumerable<Usuario> ObtenerUsuarios()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Usuario>("spUsuarioObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Usuario ObtenerUsuario(string UsuarioId)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@UsuarioID", UsuarioId);

                return con.QuerySingle<Usuario>("spUsuarioObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(string UsuarioID)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@UsuarioID", UsuarioID);

                icantFilas = con.Execute("spUsuarioEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }


        public IEnumerable<Perfil> ObtenerPerfiles()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Perfil>("spPerfilObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }
        }



        public string ActalizarGUID(string usuario_id, string sitio_web, string guid)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@UsuarioID", usuario_id);
                parameters.Add("@sitio_web", sitio_web);
                parameters.Add("@guid", (guid == "") ? null : guid);

                icantFilas = con.Execute("spUsuarioGUIDActualizar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public Usuario LoginPorGuid(string sitio_web, string guid)
        {

            Usuario usuario = new Usuario();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@sitio_web", sitio_web);
                parameter.Add("@guid", guid);
                usuario = con.QueryFirstOrDefault<Models.Usuario>("spUsuarioLoginPorGUID", parameter, commandType: CommandType.StoredProcedure);

            }

            if (usuario != null )
                return usuario;
            else
                return null;


        }

        public IEnumerable<Web> ObtenerWebs(string usuario_id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@UsuarioID", usuario_id);
                return con.Query<Web>("spUsuarioObtenerWebs", parameter, commandType: CommandType.StoredProcedure);

            }


        }


    }
}

