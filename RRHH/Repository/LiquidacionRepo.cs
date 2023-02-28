﻿using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class LiquidacionRepo:ILiquidacionRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public Liquidacion Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Liquidacion>("spLiquidacionObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }

        public IEnumerable<Liquidacion> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();

                return con.Query<Liquidacion>("spLiquidacionObtenerTodos",  commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<LiquidacionDetalle> ObtenerDetalle(int anio, int mes, int empresa_id, int ubicacion_id, int sector_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@anio", anio);
                parameter.Add("@mes", mes);
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector_id", sector_id);
                parameter.Add("@legajo_id", legajo_id);
                //parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? DateTime.Now : fecha_desde);
                //parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? DateTime.Now : fecha_hasta);

                return con.Query<LiquidacionDetalle>("spLiquidacionDetalleObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }
    }
}
