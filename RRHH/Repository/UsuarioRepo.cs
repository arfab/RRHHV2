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

            if (usuario != null && (usuario.perfil_id == 7 && clave == usuario.clave || usuario.perfil_id!=7 && BCrypt.Net.BCrypt.Verify(clave, usuario.clave)))
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
                parameters.Add("@local_id", (usuario.local_id <= 0) ? null : usuario.local_id);
                parameters.Add("@legajo_id", (usuario.legajo_id <= 0) ? null : usuario.legajo_id);


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
                parameters.Add("@local_id", (usuario.local_id <= 0) ? null :  usuario.local_id);
                parameters.Add("@legajo_id", (usuario.legajo_id <= 0) ? null : usuario.legajo_id);


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


        public string HomeOfficeFichar(int legajo_id, string tipo_fichada)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id",legajo_id);
                parameters.Add("@tipo_fichada", tipo_fichada);
 
                icantFilas = con.Execute("spHomeOfficeFichar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public DateTime? HomeOfficeObtenerEntrada(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);

                return con.QuerySingleOrDefault<DateTime>("spHomeOfficeObtenerEntrada", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public DateTime? HomeOfficeObtenerSalida(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);

                return con.QuerySingleOrDefault<DateTime>("spHomeOfficeObtenerSalida", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public int HomeOfficeObtenerCantidadEntradas(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);

                return con.QuerySingleOrDefault<int>("spHomeOfficeObtenerCantidadEntradas", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public int HomeOfficeObtenerCantidadSalidas(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);

                return con.QuerySingleOrDefault<int>("spHomeOfficeObtenerCantidadSalidas", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public IEnumerable<Usuario> ObtenerUsuarios(int perfil_id, int perfil2_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@perfil_id", perfil_id);
                parameters.Add("@perfil2_id", perfil2_id);

                return con.Query<Usuario>("spUsuarioObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
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



        public string InsertarWeb(string UsuarioID, string web, int perfil_id)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@UsuarioID", UsuarioID);
                parameters.Add("@web", web);
                parameters.Add("@perfil_id", perfil_id);


                icantFilas = con.Execute("spUsuarioWebInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public string EliminarWeb(string UsuarioID, string web)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@UsuarioID", UsuarioID);
                parameters.Add("@web", web);


                icantFilas = con.Execute("spUsuarioWebEliminar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

    }
}

