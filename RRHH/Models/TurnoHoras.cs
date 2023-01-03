using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class TurnoHoras
    {
        public int? id { get; set; }
        public int? ubicacion_id { get; set; }
        public string? ubicacion { get; set; }
        public int? turno_id { get; set; }
        public string? turno { get; set; }

        public string? tipo { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_desde { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_hasta { get; set; }
    }
}
