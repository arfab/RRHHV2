using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Feriado
    {
        public int? id { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha { get; set; }

        public string? tipo { get; set; }

        public string? descripcion { get; set; }

    }
}
