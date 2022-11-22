namespace RRHH.Models
{
    public class AjusteLectora
    {

        public int id { get; set; }

        public int lectora_id { get; set; }

        public DateTime fecha { get; set; }

        public string desde { get; set; }

        public string hasta { get; set; }

        public int delta { get; set; }

    }
}
