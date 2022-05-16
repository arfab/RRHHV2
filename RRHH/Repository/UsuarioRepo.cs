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
                usuario = con.QueryFirstOrDefault<Models.Usuario>("dwLogin", parameter, commandType: CommandType.StoredProcedure);

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


                icantFilas = con.Execute("dwUsuarioInsertar", parameters, commandType: CommandType.StoredProcedure);


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


                icantFilas = con.Execute("dwUsuarioModificar", parameters, commandType: CommandType.StoredProcedure);


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



                icantFilas = con.Execute("dwUsuarioCambiarClave", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public IEnumerable<Usuario> ObtenerUsuarios()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Usuario>("dwUsuarioObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
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

                return con.QuerySingle<Usuario>("dwUsuarioObtener", parameter, commandType: CommandType.StoredProcedure);
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

                icantFilas = con.Execute("dwUsuarioEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }



    }
}

