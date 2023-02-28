using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Liquidacion
    {
        public Int64 id { get; set; }

        public int anio { get; set; }

        public int mes { get; set; }

        public DateTime fecha_desde { get; set; }

        public DateTime fecha_hasta { get; set; }
    }
}
