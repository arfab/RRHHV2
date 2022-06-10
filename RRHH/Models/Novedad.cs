using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Novedad
    {
        public int? id { get; set; }
        public int? legajo_id { get; set; }
        public int? empresa_id { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        [Remote(action: "LegajoExiste",controller:"Novedad", AdditionalFields = "empresa_id", ErrorMessage = "El nro de legajo no existe")]
        public int? nro_legajo { get; set; }
        public string? apellido { get; set; }
        public string? nombre { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? ubicacion_id { get; set; }
        public string? ubicacion { get; set; }

        public int? sector_id { get; set; }
        public string? sector { get; set; }

        public int? responsable_id { get; set; }
        public string? responsable { get; set; }


        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? categoria_novedad_id { get; set; }
        public string? categoria_novedad { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? tipo_novedad_id { get; set; }
        public string? tipo_novedad { get; set; }
        
        public int? tipo_resolucion_id { get; set; }
        public string? tipo_resolucion { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        public string? observacion { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? concepto { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? dias { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_novedad { get; set; }
        [BindProperty, DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_resolucion { get; set; }
        public DateTime? fecha_alta { get; set; }

        public int? usuario_id { get; set; }
        public string? usuario { get; set; }

        public int? local_id { get; set; }
        public string? local { get; set; }


    }
}
