using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;


namespace RRHH.Models
{
    public class LiquidacionDetalle
    {

        public Int64 id { get; set; }

        public Int64 liquidacion_id { get; set; }

        public int anio { get; set; }

        public int mes { get; set; }

        public DateTime fecha_desde { get; set; }

        public DateTime fecha_hasta { get; set; }


        public int legajo_id { get; set; }

        public int? nro_legajo { get; set; }
        public string? apellido { get; set; }
        public string? nombre { get; set; }


        public double hs_50 { get; set; }
        public double hs_100 { get; set; }
        public double hs_50_fds { get; set; }
        public double hs_feriado { get; set; }

        public int enfermedad{ get; set; }
        public int accidente { get; set; }
        public int dias_suspension { get; set; }
        public int dias_descuento { get; set; }
        public int dias_vacaciones { get; set; }
        public double descuento_horas { get; set; }

        public int premio_presentismo { get; set; }
        public int premio_puntualidad { get; set; }
        public int premio_horas { get; set; }


        public DateTime fecha_alta { get; set; }

        public int usuario_id { get; set; }

    }
}
