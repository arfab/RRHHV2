namespace RRHH.Models
{
    public class TipoHorario
    {
        public int? ubicacion_id { get; set; }
        public string? ubicacion { get; set; }

        public int? sector_id { get; set; }
        public string? sector { get; set; }

        public int? local_id { get; set; }

        public int? tipo_hora_id { get; set; }
        public string? tipo_hora { get; set; }

        public int? tipo_dia_semana_id { get; set; }
        public string? tipo_dia { get; set; }

        public int? nro_legajo { get; set; }
        public int? legajo_id { get; set; }

        public DateTime? fecha_desde { get; set; }
        public DateTime? fecha_hasta { get; set; }

        public string? hora_desde { get; set; }
        public string? hora_hasta { get; set; }
       

        public string? empleado { get; set; }

        public string? apellido { get; set; }

        public string? nombre { get; set; }

        public string? empresa { get; set; }


        


      

    }
}
