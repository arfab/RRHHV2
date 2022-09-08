namespace RRHH.Models
{
    public class Lectora
    {
        public int id { get; set; }

        public string? descripcion { get; set; }

        public string? ip { get; set; }

        public DateTime ultima_actualizacion { get; set; }

        public int horas { get; set; }

        public int empresa_id { get; set; }

    }
}
