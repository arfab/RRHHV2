using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class LegajoFichada
    {

        public int id { get; set; }

        public int legajo_id { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)]
        public DateTime fecha { get; set; }

        public int lectora_id { get; set; }

        public string? entrada_1 { get; set; }
        public string? salida_1 { get; set; }
        public string? entrada_2 { get; set; }
        public string? salida_2 { get; set; }

     
        public string? lectora { get; set; }

        public string DiaSemana()
        {
            switch (fecha.DayOfWeek)
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
