using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class HorasNoAutorizadas
    {
        public int legajo_id { get; set; }
        public int nro_legajo { get; set; }
        public string empresa { get; set; }
        public string apellido { get; set; }
        public string nombre { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha { get; set; }
        public string? hora_desde { get; set; }
        public string? primera_fichada { get; set; }
        public string? ultima_fichada { get; set; }
    }
}
