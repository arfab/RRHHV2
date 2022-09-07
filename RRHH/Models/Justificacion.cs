using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Justificacion
    {
        public int? id { get; set; }
        public int? legajo_id { get; set; }
        public int? empresa_id { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        [Remote(action: "LegajoExiste", controller: "Novedad", AdditionalFields = "empresa_id", ErrorMessage = "El nro de legajo no existe")]
        public int? nro_legajo { get; set; }
        public string? apellido { get; set; }
        public string? nombre { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_desde { get; set; }
       
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_hasta { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? categoria_id { get; set; }
        public string? categoria { get; set; }

        public string? descripcion { get; set; }

        public DateTime? fecha_alta { get; set; }

        public int? usuario_id { get; set; }
        public string? usuario { get; set; }

        
    }
}
