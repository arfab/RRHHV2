﻿using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
{
    public class Remoto
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
        public DateTime? fecha_desde { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? fecha_hasta { get; set; }

        public DateTime? fecha_alta { get; set; }

        public int? usuario_id { get; set; }
        public string? usuario { get; set; }

        public int? ubicacion_id { get; set; }
        public string? ubicacion { get; set; }

        public int? sector_id { get; set; }
        public string? sector { get; set; }

        public int? local_id { get; set; }
        public string? local { get; set; }

        public int? empresa_id { get; set; }
        public string? empresa { get; set; }

        public string[]? legajos { get; set; }

        public int? dia_semana { get; set; }
    }
}
