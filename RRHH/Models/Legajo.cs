using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Legajo
    {
        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        //[Remote(action: "LegajoNoExiste", controller: "Legajo", ErrorMessage = "El nro de legajo ya existe")]
        public int? nro_legajo { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        public string apellido { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        public string nombre { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? sector_id { get; set; }
        public string? sector { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? categoria_id { get; set; }
        public string? categoria { get; set; }
        public int? activo { get; set; }
        public DateTime? fecha_alta { get; set; }

    }
}
