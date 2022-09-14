namespace RRHH.Models
{
    public class Fichada
    {
        public int? nro_legajo { get; set; }
        public int? legajo_id { get; set; }
        public int? lectora_id { get; set; }
        public DateTime? fecha { get; set; }
        
        public string? hora_entrada_1 { get; set; }
        public string? hora_salida_1 { get; set; }
        public string? hora_entrada_2 { get; set; }
        public string? hora_salida_2 { get; set; }

        public string? lec1 { get; set; }
        public string? tipo1 { get; set; }

        public string? lec2 { get; set; }
        public string? tipo2 { get; set; }

        public string? lec3 { get; set; }
        public string? tipo3 { get; set; }

        public string? lec4 { get; set; }
        public string? tipo4 { get; set; }

        public string? lec5 { get; set; }
        public string? tipo5 { get; set; }

        public string? lec6 { get; set; }
        public string? tipo6 { get; set; }

        public string? cantidad_horas { get; set; }

        public int? justificacion_id { get; set; }
        public string? justificacion { get; set; }

        public string? estado { get; set; }

        public string? empleado { get; set; }

        public string? apellido { get; set; }

        public string? nombre { get; set; }

        public string? empresa { get; set; }

        public string? lectora { get; set; }

        public int? lectora_nro { get; set; }

        public int? delta { get; set; }

        public string DiaSemana()
        {
            switch (fecha.Value.DayOfWeek)
            {
                case DayOfWeek.Monday:
                    return "Lun";

                case DayOfWeek.Tuesday:
                    return "Mar";

                case DayOfWeek.Wednesday:
                    return "Mié";

                case DayOfWeek.Thursday:
                    return "Jue";

                case DayOfWeek.Friday:
                    return "Vie";

                case DayOfWeek.Saturday:
                    return "Sáb";

                case DayOfWeek.Sunday:
                    return "Dom";

            }

            return "";
        }
    }
}
