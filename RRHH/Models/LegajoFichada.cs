using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class LegajoFichada
    {

        public int id { get; set; }

        public int legajo_id { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        [Remote(action: "LegajoExiste", controller: "Novedad", AdditionalFields = "empresa_id", ErrorMessage = "El nro de legajo no existe")]
        public int? nro_legajo { get; set; }
        public string? apellido { get; set; }
        public string? nombre { get; set; }

        [DisplayFormat(DataFormatString = @"{0:dd\/MM\/yyyy}", ApplyFormatInEditMode = false)]
        [DataType(DataType.Text)]
        public DateTime fecha { get; set; }

        public int lectora_id { get; set; }

        public string? entrada_1 { get; set; }
        public string? salida_1 { get; set; }
        public string? entrada_2 { get; set; }
        public string? salida_2 { get; set; }
        public string? entrada_3 { get; set; }
        public string? salida_3 { get; set; }
        public string? entrada_4 { get; set; }
        public string? salida_4 { get; set; }

        public string? horas_normales { get; set; }
        public string? horas_50 { get; set; }
        public string? horas_100 { get; set; }

        public int? empresa_id { get; set; }
        public string? empresa { get; set; }
        

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
