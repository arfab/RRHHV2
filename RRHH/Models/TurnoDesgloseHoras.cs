namespace RRHH.Models
{
    public class TurnoDesgloseHoras
    {
        public int? id { get; set; }
        public int? ubicacion_id { get; set; }
        public string? ubicacion { get; set; }
        public int? turno_id { get; set; }
        public string? turno { get; set; }

        public int cantidad_dias { get; set; }
        public int cantidad_horas_dia { get; set; }

    }
}
