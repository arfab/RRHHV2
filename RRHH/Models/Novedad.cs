using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Novedad
    {
        public int? id { get; set; }
        [Required(ErrorMessage = "El campo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? nro_legajo { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? categoria_novedad_id { get; set; }
        public string? categoria_novedad { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? tipo_novedad_id { get; set; }
        public string? tipo_novedad { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? tipo_resolucion_id { get; set; }
        public string? tipo_resolucion { get; set; }
        public string? medio_recepcion { get; set; }
        public string? observacion { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? concepto { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "El campo es requerido")]
        public int? dias { get; set; }
        public DateTime? fecha_novedad { get; set; }
        public DateTime? fecha_resolucion { get; set; }
        public DateTime? fecha_alta { get; set; }
    }
}
