using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Globalization;

namespace RRHH.Models
{
    public class LegajoHorario
    {
        public int? id { get; set; }
        public int? legajo_id { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        [Remote(action: "LegajoExiste", controller: "Novedad", AdditionalFields = "empresa_id", ErrorMessage = "El nro de legajo no existe")]
        public int? nro_legajo { get; set; }
        public string? apellido { get; set; }
        public string? nombre { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha { get; set; }


        public int? usuario_id { get; set; }
        public string? usuario { get; set; }

        public string? desde { get; set; }
        public string? hasta { get; set; }


        public string? desde2 { get; set; }
        public string? hasta2 { get; set; }

        public string? total_horas { get; set; }

        public int? cantidad_horas { get; set; }

        public int? estado { get; set; }

        public int? concepto { get; set; }

        public string? descripcion { get; set; }

        public int? valida_horas { get; set; }

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
