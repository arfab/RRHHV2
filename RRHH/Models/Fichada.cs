﻿namespace RRHH.Models
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
        public string? hora_entrada_3 { get; set; }
        public string? hora_salida_3 { get; set; }
        public string? hora_entrada_4 { get; set; }
        public string? hora_salida_4 { get; set; }

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

        public string? lec7 { get; set; }
        public string? tipo7 { get; set; }

        public string? lec8 { get; set; }
        public string? tipo8 { get; set; }

        public string? cantidad_horas { get; set; }

        public int? justificacion_id { get; set; }
        public string? justificacion { get; set; }
        public int? cantidad_justificaciones { get; set; }

        public string? estado { get; set; }

        public string? empleado { get; set; }

        public string? apellido { get; set; }

        public string? nombre { get; set; }

        public string? empresa { get; set; }

        public string? lectora { get; set; }

        public int? lectora_nro { get; set; }

        public int? delta { get; set; }
        
        public int? cantidad_lecturas { get; set; }

        public int? cantidad_lecturas_orig { get; set; }

        public int? ubicacion_id { get; set; }

        public int? sector_id { get; set; }

        public int? local_id { get; set; }


        public string? horas_normales { get; set; }

        public string? horas_50 { get; set; }

        public string? horas_100 { get; set; }

        public string? horas_50_fds { get; set; }

        public string? horas_feriado { get; set; }

        public int feriado { get; set; }

        public int descuento { get; set; }

        public string descuento_str { get; set; }

        public int? validado { get; set; }

        public int? editado { get; set; }

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
