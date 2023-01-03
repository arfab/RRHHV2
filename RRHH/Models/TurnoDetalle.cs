using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class TurnoDetalle
    {
        public int? id { get; set; }
        public int? ubicacion_id { get; set; }
        public string? ubicacion { get; set; }
        public int? turno_id { get; set; }
        public string? turno { get; set; }

        public int? tipo_hora_id { get; set; }
        public string? tipo_hora { get; set; }

        public int? tipo_dia_semana_id { get; set; }
        public string? tipo_dia { get; set; }

        public string? hora_desde { get; set; }
        public string? hora_hasta { get; set; }

        public int? almuerzo { get; set; }


    }
}
